#!/bin/bash -e

if [ "$BBN_KIND" == "LITE" ] ; then
  exit 0
fi

apt-get clean

apt-get -y -q install geographiclib-tools libexiv2-27 libnlopt0 \
 libqt6charts6 libqt6multimediawidgets6 libqt6webenginewidgets6 libqt6serialport6 # libqt6script6 stellarium stellarium-data

xargs -n 1 -P 2 wget -q << EOF
http://ppa.launchpad.net/stellarium/stellarium-releases/ubuntu/pool/main/s/stellarium/stellarium_24.1.0-upstream1.0~ubuntu22.04.1_arm64.deb
http://ppa.launchpad.net/stellarium/stellarium-releases/ubuntu/pool/main/s/stellarium/stellarium-data_24.1.0-upstream1.0~ubuntu22.04.1_all.deb
EOF

dpkg-deb -xv stellarium_*.deb /
dpkg-deb -xv stellarium-data*.deb /
chown root:root /
chmod 755 /
rm -f stellarium*.deb

install -d -o 1000 -g 1000 -m 0755 "/home/user/.stellarium"
install -v -o 1000 -g 1000 -m 0644 "$FILE_FOLDER"/stellarium-config.ini "/home/user/.stellarium/config.ini"

install -v -m 0644 "$FILE_FOLDER"/org.stellarium.Stellarium.desktop /usr/share/applications/
install -v -m 0755 "$FILE_FOLDER"/stellarium-augmented.sh /usr/local/bin/stellarium-augmented

geographiclib-get-magnetic all

apt-get clean

apt-mark hold stellarium stellarium-data
