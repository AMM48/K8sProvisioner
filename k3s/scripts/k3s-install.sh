#!/bin/bash

echo "##########################################################################################"
echo "#                      ⏳ STEP 3: INSTALLING AND CONFIGURING K3S 🚀                      #"
echo "##########################################################################################"

IP_ADDRESS=$1
flags="--node-ip $IP_ADDRESS --flannel-backend none --disable traefik"

curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="$flags" K3S_KUBECONFIG_MODE="644" sh -

echo "export K3S_TOKEN=$(sudo cat /var/lib/rancher/k3s/server/node-token)" >> /vagrant/k3s-token.sh
echo "export NODE_IP=$IP_ADDRESS" >> /vagrant/k3s-token.sh

mkdir ./.kube
cp /etc/rancher/k3s/k3s.yaml ./.kube
mv ./.kube/k3s.yaml ./.kube/config

chmod 600 /home/vagrant/.kube/config

kubectl get nodes -o wide

echo "########################################################################################"
echo "#                   ✅ K3S INSTALLED AND CONFIGURED SUCCESSFULLY! 🎉                   #"
echo "########################################################################################"