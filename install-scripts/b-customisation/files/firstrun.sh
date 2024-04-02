#!/bin/bash

set +e

export NEW_HOSTNAME=lysmarine
export WIFI_NAME="lysmarine-hotspot"
export WIFI_PSK="9edadd0c8b779a33b4f336efa49535aa9a5a1c7809a457abb71fd68a1925d91f"
export WIFI_COUNTRY="GB"
export LOCALE=gb
export TIMEZONE=Europe/London
export USER_PWD='$5$kz4zawSHO0$YGfJYc6XJ0l/McEKhUUGqfvlwUgpMvsrwbSCErM/zN2'
export DOMAIN='local'

if [ -f /boot/firmware/settings.env ]; then
   source /boot/firmware/settings.env
   rm -f /boot/firmware/settings.env

   if [[ "$WIFI_PASSPHRASE" != "" ]]; then
      WIFI_PSK=`wpa_passphrase "$WIFI_NAME" "$WIFI_PASSPHRASE"`
   fi
fi

CURRENT_HOSTNAME=`cat /etc/hostname | tr -d " \t\n\r"`
if [ -f /usr/lib/raspberrypi-sys-mods/imager_custom ]; then
   /usr/lib/raspberrypi-sys-mods/imager_custom set_hostname $NEW_HOSTNAME
else
   echo $NEW_HOSTNAME >/etc/hostname
   sed -i "s/127.0.1.1.*$CURRENT_HOSTNAME/127.0.1.1\t$NEW_HOSTNAME/g" /etc/hosts
fi
FIRSTUSER=`getent passwd 1000 | cut -d: -f1`
FIRSTUSERHOME=`getent passwd 1000 | cut -d: -f6`

if [[ "$USER_PASSWORD" != "" ]]; then
   USER_PWD=`mkpasswd -m sha-256 $USER_PASSWORD`
fi

if [ -f /usr/lib/userconf-pi/userconf ]; then
   /usr/lib/userconf-pi/userconf 'user' "$USER_PWD"
else
   echo "$FIRSTUSER:$USER_PWD" | chpasswd -e
   if [ "$FIRSTUSER" != "user" ]; then
      usermod -l "user" "$FIRSTUSER"
      usermod -m -d "/home/user" "user"
      groupmod -n "user" "$FIRSTUSER"
      if grep -q "^autologin-user=" /etc/lightdm/lightdm.conf ; then
         sed /etc/lightdm/lightdm.conf -i -e "s/^autologin-user=.*/autologin-user=user/"
      fi
      if [ -f /etc/systemd/system/getty@tty1.service.d/autologin.conf ]; then
         sed /etc/systemd/system/getty@tty1.service.d/autologin.conf -i -e "s/$FIRSTUSER/user/"
      fi
      if [ -f /etc/sudoers.d/010_pi-nopasswd ]; then
         sed -i "s/^$FIRSTUSER /user /" /etc/sudoers.d/010_pi-nopasswd
      fi
   fi
fi

if [ -f /usr/lib/raspberrypi-sys-mods/imager_custom ]; then
   /usr/lib/raspberrypi-sys-mods/imager_custom set_wlan "$WIFI_NAME" "$WIFI_PSK" "$WIFI_COUNTRY"
else

   if [ "$WIFI_NAME" =~ ".*hotspot" ]; then

      cat << \NMCONN > /etc/NetworkManager/system-connections/preconfigured-hotspot.nmconnection
[connection]
id=$WIFI_NAME
uuid=cabf5cf8-e457-4480-bfdb-17e8e2c8a327
type=wifi
interface-name=wlan0
permissions=user:user:;

[wifi]
band=bg
mac-address-blacklist=
mode=ap
ssid=$WIFI_NAME

[wifi-security]
key-mgmt=wpa-psk
pairwise=ccmp
psk=$WIFI_PSK

[ipv4]
dns-search=
method=shared

[ipv6]
addr-gen-mode=stable-privacy
dns-search=
ip6-privacy=0
method=ignore

NMCONN

      chmod -R 600 /etc/NetworkManager/system-connections/preconfigured-hotspot.nmconnection
      chown -R root:root /etc/NetworkManager/system-connections/preconfigured-hotspot.nmconnection
      systemctl restart NetworkManager 
      nmcli con up $WIFI_NAME


   else

      cat << \NMCONN > /etc/NetworkManager/system-connections/preconfigured-wifi.nmconnection
[connection]
id=$WIFI_NAME
uuid=85c59f45-1f62-434e-9d5a-cf715a0c9b0d
type=wifi
autoconnect=true
[wifi]
mode=infrastructure
ssid=$WIFI_NAME
hidden=false
[ipv4]
method=auto
[ipv6]
addr-gen-mode=default
method=auto
[proxy]
[wifi-security]
key-mgmt=wpa-psk
psk=$WIFI_PSK

NMCONN

      chmod -R 600 /etc/NetworkManager/system-connections/preconfigured-wifi.nmconnection
      chown -R root:root /etc/NetworkManager/system-connections/preconfigured-wifi.nmconnection
      systemctl restart NetworkManager 
      nmcli con up $WIFI_NAME

   fi
fi

if [ -f /usr/lib/raspberrypi-sys-mods/imager_custom ]; then
   /usr/lib/raspberrypi-sys-mods/imager_custom set_keymap "$LOCALE"
   /usr/lib/raspberrypi-sys-mods/imager_custom set_timezone "$TIMEZONE"
else
   rm -f /etc/localtime
   echo "$TIMEZONE" >/etc/timezone
   dpkg-reconfigure -f noninteractive tzdata
cat >/etc/default/keyboard <<\KBEOF
XKBMODEL="pc105"
XKBLAYOUT="$LOCALE"
XKBVARIANT=""
XKBOPTIONS=""

KBEOF
   dpkg-reconfigure -f noninteractive keyboard-configuration
fi

if [ -d /boot/firmware/firstrun-scripts ]; then
   cd /boot/firmware/firstrun-scripts
   for runScript in /boot/firmware/firstrun-scripts/*.sh; do
    if [ -f "$runScript" ]; then
      chmod +x "$runScript"
      $runScript
    fi
   done
   cd -
   rm -rf /boot/firmware/firstrun-scripts
fi

rm -f /boot/firmware/firstrun.sh
sed -i 's| systemd.run.*||g' /boot/firmware/cmdline.txt
exit 0
