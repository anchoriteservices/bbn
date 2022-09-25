#!/bin/bash -e

usermod -a -G pypilot user

## Install the service files
install -v -m 0644 $FILE_FOLDER/pypilot@.service "/etc/systemd/system/"
install -v -m 0644 $FILE_FOLDER/pypilot_boatimu.service "/etc/systemd/system/"
install -v -m 0644 $FILE_FOLDER/pypilot_web.service "/etc/systemd/system/"
install -v -m 0644 $FILE_FOLDER/pypilot_hat.service "/etc/systemd/system/"
install -v -m 0644 $FILE_FOLDER/pypilot_detect.service "/etc/systemd/system/"

sed -i 's/_http._tcp.local./_signalk-http._tcp.local./' "$(find /usr/local/lib -name signalk.py)" || true
#sed -i 's/ttyAMA0/serial1/' "$(find /usr/local/lib -name serialprobe.py)" || true
#sed -i "s/'ttyAMA'//" "$(find /usr/local/lib -name serialprobe.py)" || true

#cp $FILE_FOLDER/wind.py "$(find /usr/local/lib -name wind.py)" || true

systemctl disable pypilot_boatimu.service
systemctl disable pypilot_hat.service
systemctl enable pypilot@pypilot.service                               # listens on tcp 20220 and 23322
systemctl enable pypilot_web.service                                   # listens on tcp 8080
systemctl enable pypilot_detect.service                                # tries to detect pypilot hardware (hat)

## Install the user config files
rm -rf /home/pypilot/.pypilot
rm -rf /home/tc
install -v -o pypilot -g pypilot -m 0775 -d "/home/pypilot/.pypilot"
install -v -o pypilot -g pypilot -m 0775 -d "/home/tc"
ln -s /home/pypilot/.pypilot "/home/user/.pypilot"
ln -s /home/pypilot/.pypilot "/home/tc/.pypilot"
setfacl -d -m g:pypilot:rw "/home/pypilot"
setfacl -d -m g:pypilot:rw "/home/pypilot/.pypilot"
setfacl -d -m g:pypilot:rw "/home/tc"

install -v -o pypilot -g pypilot -m 0664 $FILE_FOLDER/signalk.conf "/home/pypilot/.pypilot/"
install -v -o pypilot -g pypilot -m 0664 $FILE_FOLDER/webapp.conf "/home/pypilot/.pypilot/"
install -v -o pypilot -g pypilot -m 0664 $FILE_FOLDER/pypilot_client.conf "/home/pypilot/.pypilot/"
install -v -o pypilot -g pypilot -m 0664 $FILE_FOLDER/hat.conf "/home/pypilot/.pypilot/"
install -v -o pypilot -g pypilot -m 0664 $FILE_FOLDER/blacklist_serial_ports "/home/pypilot/.pypilot/"
install -v -o pypilot -g pypilot -m 0664 $FILE_FOLDER/serial_ports "/home/pypilot/.pypilot/serial_ports.sample"
install -v -o pypilot -g pypilot -m 0664 $FILE_FOLDER/servodevice "/home/pypilot/.pypilot/servodevice.sample"
install -v -o pypilot -g pypilot -m 0664 $FILE_FOLDER/nmea0device "/home/pypilot/.pypilot/nmea0device.sample"

if [[ -f /home/pypilot/.pypilot/pypilot.conf ]]; then
  chmod 664 /home/pypilot/.pypilot/pypilot.conf
  chown pypilot:pypilot /home/pypilot/.pypilot/pypilot.conf
fi

install -v -g pypilot -m 0664 $FILE_FOLDER/lircd.conf "/etc/lirc/lircd.conf.d/lircd-pypilot.conf"

# prevent pypilot from changing port
sed -i 's/8000/8080/' /etc/systemd/system/pypilot_web.service || true

# TODO: temp patch
install -m 644 $FILE_FOLDER/wind.py "$(find /usr/local/lib -name wind.py)"

# TODO: not needed after changing pypilot service working directory
echo > /RTIMULib.ini
chown pypilot:pypilot /RTIMULib.ini
chmod 664 /RTIMULib.ini

