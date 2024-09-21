#!/bin/bash

echo "##########################################################################################"
echo "#             ⏳ STEP 4: CONFIGURING KUBERNETES REPO AND INSTALLING TOOLS 🚀             #"
echo "##########################################################################################"

source /vagrant/scripts/common.sh

if ls /etc/apt/keyrings > /dev/null 2>&1; then
  echo "Directory exists"
else
  sudo mkdir -p -m 755 /etc/apt/keyrings
  echo "Directory '/etc/apt/keyrings' created"
fi

retries "sudo curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.30/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg" \
"Failed to download kubernetes repository key."
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.30/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list

retries "sudo apt -y -qq update" "Failed to update apt repository."
retries "sudo apt -y -qq install kubelet kubeadm kubectl" "Failed to install kubernetes tools."
sudo apt-mark hold kubelet kubeadm kubectl

sudo systemctl enable --now kubelet

echo "##########################################################################################"
echo "#           ✅ KUBERNETES REPO CONFIGURED AND TOOLS INSTALLED SUCCESSFULLY! 🎉           #"
echo "##########################################################################################"