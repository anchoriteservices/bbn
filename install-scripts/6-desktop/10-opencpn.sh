#!/bin/bash -e

apt-get install -y -q -o Dpkg::Options::="--force-overwrite" libsglock opencpn-sglock-arm32

apt-get install -y -q opencpn opencpn-plugin-celestial opencpn-plugin-launcher opencpn-plugin-radar \
   opencpn-plugin-pypilot opencpn-plugin-objsearch opencpn-plugin-iacfleet imgkap

install -o 1000 -g 1000 -d "/home/user/.opencpn"
install -o 1000 -g 1000 -v $FILE_FOLDER/opencpn.conf "/home/user/.opencpn/"
install -o 1000 -g 1000 -v $FILE_FOLDER/opencpn.conf "/home/user/.opencpn/opencpn.conf-bbn"
install -o 1000 -g 1000 -v $FILE_FOLDER/opencpn.conf-highres-bbn "/home/user/.opencpn/opencpn.conf-highres-bbn"

if [ $LMARCH == 'armhf' ]; then
  apt-get install -y -q                                         \
    opencpn-doc                                                 \
    opencpn-plugin-calculator                                   \
    opencpn-plugin-celestial                                    \
    opencpn-plugin-chartscale                                   \
    opencpn-plugin-climatology                                  \
    opencpn-plugin-climatology-data                             \
    opencpn-plugin-iacfleet                                     \
    opencpn-plugin-launcher                                     \
    opencpn-plugin-nmeaconverter                                \
    opencpn-plugin-objsearch                                    \
    opencpn-plugin-ocpndebugger                                 \
    opencpn-plugin-plots                                        \
    opencpn-plugin-pypilot                                      \
    opencpn-plugin-radar                                        \
    opencpn-plugin-s63                                          \
    opencpn-plugin-sar                                          \
    opencpn-plugin-tactics                                      \
    opencpn-plugin-vfkaps                                       \
    opencpn-plugin-watchdog                                     \
    opencpn-plugin-weatherfax                                   \
    opencpn-plugin-weatherrouting                               \
    opencpn-plugin-draw
fi

# Polar Diagrams

BK_DIR="$(pwd)"

mkdir /home/user/Polars && cd /home/user/Polars

wget https://www.seapilot.com/wp-content/uploads/2018/05/All_polar_files.zip
unzip All_polar_files.zip
chown user:user ./*
chmod 664 ./*
rm All_polar_files.zip

cd "$BK_DIR"


# Install plugin bundle
if [ $LMARCH == 'arm64' ]; then
  exit 0
fi

mkdir tmp-o-bundle-$LMARCH || exit 2
cd tmp-o-bundle-$LMARCH

wget -O opencpn-plugins-bundle-o_5_6_x-$LMARCH.tar.gz https://github.com/bareboat-necessities/opencpn-plugins-bundle/blob/main/bundles/opencpn-plugins-bundle-o_5_6_x-$LMARCH.tar.gz?raw=true
gzip -cd opencpn-plugins-bundle-o_5_6_x-$LMARCH.tar.gz | tar xvf -

cp -r -p lib/* /usr/lib/
cp -r -p bin/* /usr/bin/
cp -r -p share/* /usr/share/

cd ..
rm -rf tmp-o-bundle-$LMARCH

if [ -f /usr/lib/opencpn/libPolar_pi.so ]; then
  mv /usr/lib/opencpn/libPolar_pi.so /usr/lib/opencpn/libpolar_pi.so
fi

if [ -f /usr/lib/opencpn/liblogbookkonni_pi.so ]; then
  rm -f /usr/lib/opencpn/libLogbookKonni_pi.so
fi

