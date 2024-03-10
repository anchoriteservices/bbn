#!/bin/bash -e

install -d /boot/firstrun-scripts
cp -r "$FILE_FOLDER"firstrun-scripts/ /boot/firstrun-scripts/
chmod -R +x /boot/firstrun-scripts
chmod -R 0644 /boot/firstrun-scripts
#(find "$FILE_FOLDER"firstrun-scripts -type f -exec install -Dm 0644 "{}" "/boot/firstrun-scripts/{}" \;)

# Replace firstrun.sh
install -v -m0644 "$FILE_FOLDER"firstrun.sh "/boot/"

install -d /mnt/boat/opencpn
mv -r /home/user/.opencpn /mnt/boat/opencpn
ln -s /mnt/boat/opencpn /home/user/.opencpn

install -d /mnt/boat/polars
mv -r /home/user/Polars /mnt/boat/polars
ln -s /mnt/boat/polars /home/user/Polars

install -d /mnt/boat/charts
mv -r /home/user/charts /mnt/boat/charts
ln -s /mnt/boat/charts /home/user/charts


if [ -f /etc/default/grub ] ; then
  install -m0644 -v "$FILE_FOLDER"background.png "/boot/grub/background.png"
  update-initramfs -u
  update-grub
fi

install -v "$FILE_FOLDER"ascii_logo.txt "/etc/motd"
cp "$FILE_FOLDER"background.png "/usr/share/plymouth/themes/dreams/background.png"
