#!/bin/bash -e
. ../lib.sh

install -d /etc/rancher/k3s
substAndInstall "$FILE_FOLDER"/k3s.yaml "/etc/rancher/k3s/config.yaml"

curl -sfL https://get.k3s.io | sh - 

# define what Helm version and where to install:
export HELM_VERSION=v3.0.2
export HELM_INSTALL_DIR=/usr/local/bin

# download the binary and get into place:
wget https://get.helm.sh/helm-$HELM_VERSION-linux-arm64.tar.gz
tar xvzf helm-$HELM_VERSION-linux-arm64.tar.gz
sudo mv linux-arm64/helm $HELM_INSTALL_DIR/helm

# clean up:
rm -rf linux-arm64 && rm helm-$HELM_VERSION-linux-arm64.tar.gz

# add the official stable charts repo:
helm repo add stable https://kubernetes-charts.storage.googleapis.com/

# add another repo:
helm repo add bitnami https://charts.bitnami.com/bitnami

helm repo add anchoriteservices https://anchoriteservices.github.io/helm-charts
