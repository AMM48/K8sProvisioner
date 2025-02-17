#!/bin/bash

echo "#########################################################################################"
echo "#             ⏳ STEP 3: INSTALLING CONTAINERD AND REQUIRED DEPENDENCIES 🚀             #"
echo "#########################################################################################"

source /vagrant/scripts/common.sh

retries "sudo wget -q --https-only --timestamping --show-progress \
-e dotbytes=1M https://github.com/containerd/containerd/releases/download/v1.7.20/containerd-1.7.20-linux-amd64.tar.gz" \
"Failed to download containerd."

retries "sudo wget -q --https-only --timestamping --show-progress \
-e dotbytes=30 https://raw.githubusercontent.com/containerd/containerd/main/containerd.service" \
"Failed to download containerd service."

retries "sudo wget -q --https-only --timestamping --show-progress \
-e dotbytes=250K https://github.com/opencontainers/runc/releases/download/v1.1.13/runc.amd64" \
"Failed to download runc."

retries "sudo wget -q --https-only --timestamping --show-progress \
-e dotbytes=1M https://github.com/containernetworking/plugins/releases/download/v1.5.1/cni-plugins-linux-amd64-v1.5.1.tgz" \
"Failed to download cni plugins."

sudo tar Cxzvf /usr/local containerd-1.7.20-linux-amd64.tar.gz > /dev/null
sudo mv containerd.service /etc/systemd/system

if ls /etc/containerd > /dev/null 2>&1; then
  echo "Directory exists"
else
  sudo mkdir -p /etc/containerd
  echo "Directory '/etc/containerd' created"
fi

sudo containerd config default | sudo tee /etc/containerd/config.toml > /dev/null
sudo sed -i 's/ SystemdCgroup = false/ SystemdCgroup = true/' /etc/containerd/config.toml

sudo systemctl daemon-reload
sudo systemctl enable --now containerd

sudo install -m 755 runc.amd64 /usr/local/sbin/runc

sudo mkdir -p /opt/cni/bin
sudo tar Cxzvf /opt/cni/bin cni-plugins-linux-amd64-v1.5.1.tgz > /dev/null
sudo chown root:root /opt/cni/bin

rm containerd-1.7.20-linux-amd64.tar.gz runc.amd64 cni-plugins-linux-amd64-v1.5.1.tgz

echo "#########################################################################################"
echo "#               ✅ CONTAINERD AND DEPENDENCIES INSTALLED SUCCESSFULLY! 🎉               #"
echo "#########################################################################################"