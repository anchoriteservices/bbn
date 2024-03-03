#!/bin/bash -e

install -d /boot/firstrun-scripts
cp -r "$FILE_FOLDER"firstrun-scripts/ /boot/firstrun-scripts/
chmod -R +x /boot/firstrun-scripts
chmod -R 0644 /boot/firstrun-scripts
#(find "$FILE_FOLDER"firstrun-scripts -type f -exec install -Dm 0644 "{}" "/boot/firstrun-scripts/{}" \;)

# Replace firstrun.sh
install -v -m0644 "$FILE_FOLDER"firstrun.sh "/boot/"
