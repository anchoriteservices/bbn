#!/bin/bash -e

apt-get install -y -q libglew2.2 gettext libwxsvg3 libtinyxml2.6.2v5 libunarr1 libwxgtk-webview3.2-1 wx3.2-i18n

install -o 1000 -g 1000 -d "/home/user/.opencpn"
install -o 1000 -g 1000 -d "/home/user/.opencpn/plugins"
install -o 1000 -g 1000 -d "/home/user/.opencpn/plugins/weather_routing"
install -o 1000 -g 1000 -d "/home/user/.opencpn/plugins/weather_routing/data"
install -o 1000 -g 1000 -v "$FILE_FOLDER"/opencpn.conf "/home/user/.opencpn/"
install -o 1000 -g 1000 -v "$FILE_FOLDER"/opencpn.conf "/home/user/.opencpn/opencpn.conf-bbn"
install -o 1000 -g 1000 -v "$FILE_FOLDER"/opencpn.conf-highres-bbn "/home/user/.opencpn/opencpn.conf-highres-bbn"

# Polar Diagrams

BK_DIR="$(pwd)"

mkdir /home/user/Polars && cd /home/user/Polars

wget https://www.seapilot.com/wp-content/uploads/2018/05/All_polar_files.zip
unzip All_polar_files.zip
chown user:user ./*
chmod 664 ./*
rm All_polar_files.zip

cd "$BK_DIR"

# mkdir tmp-o-bundle-"$LMARCH" || exit 2
# cd tmp-o-bundle-"$LMARCH"

# if [ "$BBN_KIND" == "LITE" ] ; then
#   wget -O opencpn-plugins-bundle-"$LMARCH".tar.gz https://github.com/bareboat-necessities/lysmarine_gen/releases/download/vTest/opencpn-plugins-bundle-o_5_8_x-bookworm-lite-"$LMARCH".tar.gz
# else
#   wget -O opencpn-plugins-bundle-"$LMARCH".tar.gz https://github.com/bareboat-necessities/lysmarine_gen/releases/download/vTest/opencpn-plugins-bundle-o_5_8_x-bookworm-full-"$LMARCH".tar.gz
# fi
# gzip -cd opencpn-plugins-bundle-"$LMARCH".tar.gz | tar xvf -

# mkdir -p /home/user/.local/lib /home/user/.local/bin /home/user/.local/share /home/user/.local/doc /home/user/.local/include
# cp -r -p lib/* /home/user/.local/lib/
# cp -r -p bin/* /home/user/.local/bin/ || true
# cp -r -p share/* /home/user/.local/share/
# cp -r -p doc/* /home/user/.local/doc/ || true
# cp -r -p include/* /home/user/.local/include/ || true

# chown -R user:user /home/user/.local

# cd ..
# rm -rf tmp-o-bundle-"$LMARCH"

# if [ -f /home/user/.local/lib/opencpn/libPolar_pi.so ]; then
#   mv /home/user/.local/lib/opencpn/libPolar_pi.so /usr/lib/opencpn/libpolar_pi.so
# fi

# if [ -f /home/user/.local/lib/opencpn/liblogbookkonni_pi.so ]; then
#   rm -f /home/user/.local/lib/opencpn/libLogbookKonni_pi.so
# fi

# mv /home/user/.local/share/opencpn/plugins/tactics_pi/data/Tactics.svg /home/user/.local/share/opencpn/plugins/tactics_pi/data/tactics.svg
# mv /home/user/.local/share/opencpn/plugins/tactics_pi/data/Tactics_rollover.svg /home/user/.local/share/opencpn/plugins/tactics_pi/data/tactics_rollover.svg
# mv /home/user/.local/share/opencpn/plugins/tactics_pi/data/Tactics_toggled.svg /home/user/.local/share/opencpn/plugins/tactics_pi/data/tactics_toggled.svg
# #mv /home/user/.local/share/opencpn/plugins/CanadianTides_pi/data/canadiantides_panel_icon.png /home/user/.local/share/opencpn/plugins/CanadianTides_pi/data/CanadianTides_panel_icon.png

# wget --no-check-certificate https://download.tuxfamily.org/xinutop/rastow/rastow-0.4.tgz
# gzip -cd rastow-0.4.tgz | tar xvf -
# mv rastow.sh /usr/local/bin
# rm rastow-0.4.tgz
# wget --no-check-certificate https://download.tuxfamily.org/xinutop/rastow/readme.txt
# mkdir /usr/local/share/rastow
# mv readme.txt /usr/local/share/rastow/

# # TODO: temp fix
# wget https://github.com/bareboat-necessities/lysmarine_gen/releases/download/vTest/opencpn_5.8.4+8089+1637c28fb.ubuntu22.04.1_arm64.deb
# dpkg -i opencpn_5.8.4+8089+1637c28fb.ubuntu22.04.1_arm64.deb
# rm opencpn_5.8*_arm64.deb
# rm /etc/apt/sources.list.d/opencpn.list
apt install opencpn


# ImgKap https://github.com/nohal
apt-get -y install libfreeimage-dev
git clone --depth=1 https://github.com/nohal/imgkap
cd imgkap
make -j 4
make install
cd ..
rm -rf imgkap

# for OpenCPN
#ln -s /usr/share/opencpn/tcdata/harmonics-dwf-20220109/harmonics-dwf-20220109-free.tcd /usr/share/opencpn/tcdata/harmonics-dwf-20210110-free.tcd

install -v "$FILE_FOLDER"/opencpn.desktop "/usr/share/applications/"
install -o 1000 -g 1000 -m 644 -v "$FILE_FOLDER"/opencpn.desktop "/home/user/.config/autostart/"

apt-mark hold opencpn
