#!/bin/bash

echo "⏳🚀 Step 3: Installing and setting up K3s..."

IP_ADDRESS=$1
flags="--node-ip $IP_ADDRESS --flannel-backend none --disable traefik"

echo "⏳🚀 Installing K3s..."
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="$flags" K3S_KUBECONFIG_MODE="644" sh -
echo "✅ Done!"

echo "⏳🚀 Exporting K3s token and master IP..."
echo "export K3S_TOKEN=$(sudo cat /var/lib/rancher/k3s/server/node-token)" >> /vagrant/k3s-token.sh
echo "export NODE_IP=$IP_ADDRESS" >> /vagrant/k3s-token.sh
echo "✅ Done!"

echo "⏳🚀 Creating .kube directory..."
mkdir ./.kube
echo "✅ Done!"

echo "⏳🚀 Copying K3s kubeconfig..."
cp /etc/rancher/k3s/k3s.yaml ./.kube
echo "✅ Done!"

echo "⏳🚀 Renaming kubeconfig file to 'config'..."
mv ./.kube/k3s.yaml ./.kube/config
echo "✅ Done!"

echo "⏳🚀 Setting config file permissions to 600..."
chmod 600 /home/vagrant/.kube/config
echo "✅ Done!"

kubectl get nodes -o wide

echo "✅ Installing and setting up K3s Complete!"
echo "_____________________________________________________________"