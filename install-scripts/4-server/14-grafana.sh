#!/bin/bash -e

apt-get clean

apt-get -y -q install grafana=9.0.6

systemctl disable grafana-server

apt-get clean

