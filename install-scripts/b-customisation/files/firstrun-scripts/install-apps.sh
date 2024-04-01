#! /bin/bash -e

CERTMAN_VERSION=${CERTMAN_VERSION:=1.13.3}

helm repo update

# CLOUDFLARE
cp -rf /boot/firmware/firstrun-scripts/files/.cloudflared /mnt/boat/cloudflared
ln -s /mnt/boat/cloudflared /home/user/.cloudflared
chown -R user:user /mnt/boat/cloudflared
chmod -R 755 /mnt/boat/cloudflared

CLOUDFLARE_CONFIG=`find /mnt/boat/cloudflared -type f -name "*.json"`
kubectl create secret generic tunnel-credentials --from-file=credentials.json=\$CLOUDFLARE_CONFIG
helm install -f infrastructure/cloudflare-values.yaml cloudflare/cloudflare-tunnel

kubectl apply -f https://github.com/jetstack/cert-manager/releases/download/v${CERTMAN_VERSION}/cert-manager.yaml
cat infrastructure/letsencrypt.yaml | envsubst | kubectl apply -f -

sudo mkdir -p /mnt/k3s/home-assistant/config
kubectl apply -f home-assistant/storage.yaml
helm install home-assistant anchoriteservices/app-template --values home-assistant/helm-values.yaml

sudo mkdir -p /mnt/k3s/mqtt/data
sudo mkdir -p /mnt/k3s/mqtt/config
kubectl apply -f mqtt/storage.yaml
helm install mqtt anchoriteservices/app-template --values mqtt/helm-values.yaml

helm repo add mojo2600 https://mojo2600.github.io/pihole-kubernetes/
helm repo update

sudo mkdir -p /mnt/k3s/pihole/config
kubectl apply -f pihole/storage.yaml
helm upgrade --install pihole mojo2600/pihole --set hostIP=$(hostname -I | awk '{print $1}') -f pihole/helm-values.yaml
