#!/bin/bash -e

cp -r "$FILE_FOLDER"firstrun-scripts /boot
chmod -R +x /boot/firstrun-scripts
chmod -R 0644 /boot/firstrun-scripts
#(find "$FILE_FOLDER"firstrun-scripts -type f -exec install -Dm 0644 "{}" "/boot/firstrun-scripts/{}" \;)

# Replace firstrun
install -m 755 "$FILE_FOLDER"firstrun "/usr/local/sbin/firstrun"
install -v -m0644 "$FILE_FOLDER"firstrun.sh "/boot/"
install -m 755 "$FILE_FOLDER"first-boot.sh "/boot/first-boot.sh"
install -m 755 "$FILE_FOLDER"settings.env "/boot/settings.env"


install -d /mnt/boat

mv /home/user/.opencpn /mnt/boat/opencpn
ln -s /mnt/boat/opencpn /home/user/.opencpn

mv /home/user/Polars /mnt/boat/polars
ln -s /mnt/boat/polars /home/user/Polars

mv /home/user/charts /mnt/boat/charts
ln -s /mnt/boat/charts /home/user/charts

mv /home/user/.config /mnt/boat/config
ln -s /mnt/boat/config /home/user/.config

mv /home/user/.local /mnt/boat/local
ln -s /mnt/boat/local /home/user/.local

mv /home/signalk/.signalk /mnt/boat/signalk
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
