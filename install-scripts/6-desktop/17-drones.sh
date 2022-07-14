#!/bin/bash -e

apt-get install -y libqt5quickwidgets5 libqt5widgets5 libqt5gui5 libqt5webkit5 libqt5sql5 libqt5printsupport5 libqt5network5 libqt5serialport5 \
 libqt5svg5 libqt5opengl5 libqt5test5 libqt5xml5 libqt5qml5 qml-module-qtquick-controls libsndfile1

# https://github.com/ArduPilot/apm_planner
wget https://github.com/bareboat-necessities/apm_planner_4rpi/releases/download/v2.0.29-rc1-16-g339533bfb/apmplanner2_2.0.29-rc1-16-g339533bfb_armhf.deb
dpkg -i apmplanner2_2.0.29-rc1-16-g339533bfb_armhf.deb && rm -f apmplanner2_2.0.29-rc1-16-g339533bfb_armhf.deb

bash -c 'cat << EOF > /usr/local/share/applications/apmplanner2.desktop
[Desktop Entry]
Type=Application
Name=ApmPlanner2
GenericName=ApmPlanner2
Comment=Drone Control Station
Exec=onlyone apmplanner2
Terminal=false
Icon=gnome-globe
Categories=Navigation;
EOF'
