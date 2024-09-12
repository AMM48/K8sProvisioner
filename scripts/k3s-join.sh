#!/bin/bash

echo "⏳🚀 Step 3: Joining worker nodes to cluster..."

IP_ADDRESS=$1

echo "⏳🚀 Setting up environment variables..."
source /vagrant/k3s-token.sh
echo "✅ Done!"

echo "⏳🚀 Joining worker node..."
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="agent --node-ip=$IP_ADDRESS" K3S_URL=https://$NODE_IP:6443 K3S_TOKEN=$K3S_TOKEN sh -s -
echo "✅ Done!"

echo "✅ Joining worker nodes to cluster Complete!"
echo "_____________________________________________________________"