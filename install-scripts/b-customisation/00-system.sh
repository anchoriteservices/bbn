#!/bin/bash -e

install -d /boot/firstrun-scripts
cp -r "$FILE_FOLDER"firstrun-scripts /boot/firstrun-scripts
chmod -R +x /boot/firstrun-scripts
chmod -R 0644 /boot/firstrun-scripts
#(find "$FILE_FOLDER"firstrun-scripts -type f -exec install -Dm 0644 "{}" "/boot/firstrun-scripts/{}" \;)

# Replace firstrun
install -m 755 "$FILE_FOLDER"/firstrun "/usr/local/sbin/firstrun"
install -v -m0644 "$FILE_FOLDER"firstrun.sh "/boot/"
install -m 755 "$FILE_FOLDER"/first-boot.sh "/boot/first-boot.sh"


install -d /mnt/boat/opencpn
mv /home/user/.opencpn /mnt/boat/opencpn/
ln -s /mnt/boat/opencpn /home/user/.opencpn

install -d /mnt/boat/polars
mv /home/user/Polars /mnt/boat/polars/
ln -s /mnt/boat/polars /home/user/Polars

install -d /mnt/boat/charts
mv /home/user/charts /mnt/boat/charts/
ln -s /mnt/boat/charts /home/user/charts

install -d /mnt/boat/config
mv /home/user/.config /mnt/boat/config/
ln -s /mnt/boat/config /home/user/.config

install -d /mnt/boat/local
mv /home/user/.local /mnt/boat/local/
ln -s /mnt/boat/local /home/user/.local

install -d /mnt/boat/signalk
mv /home/signalk/.signalk /mnt/boat/signalk/
ln -s /mnt/boat/signalk /home/signalk/.signalk


chown -R user:user /mnt/boat
chown -R signalk:signalk /mnt/boat/signalk
chmod -R 755 /mnt/boat


if [ -f /etc/default/grub ] ; then
  install -m0644 -v "$FILE_FOLDER"background.png "/boot/grub/background.png"
  update-initramfs -u
  update-grub
fi

install -v "$FILE_FOLDER"ascii_logo.txt "/etc/motd"
cp "$FILE_FOLDER"background.png "/usr/share/plymouth/themes/dreams/background.png"
