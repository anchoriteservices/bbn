#!/bin/bash -e

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
