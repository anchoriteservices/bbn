#!/bin/bash -e

apt-get -y autoremove
apt-get clean
npm cache clean --force || true

sed -i 's/#RebootWatchdogSec=10min/RebootWatchdogSec=75s/' /etc/systemd/system.conf

# Fill free space with zeros
cat /dev/zero > /zer0s || true
rm -f /zer0s
