#!/bin/bash

echo "##########################################################################################"
echo "#                      ⏳ STEP 5: INSTALLING AND CONFIGURING K8S 🚀                      #"
echo "##########################################################################################"

source /vagrant/scripts/common.sh

IP_ADDRESS=$1

retries "sudo kubeadm config images pull" "Failed to pull config images."
retries "sudo kubeadm init --apiserver-advertise-address=$IP_ADDRESS --pod-network-cidr=10.244.0.0/16" "Failed to initalize cluster."

echo "export TOKEN='$(sudo kubeadm token create --print-join-command)'" >> /vagrant/token.sh

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

kubectl taint nodes $HOSTNAME node-role.kubernetes.io/control-plane:NoSchedule-

echo "########################################################################################"
echo "#                   ✅ K8S INSTALLED AND CONFIGURED SUCCESSFULLY! 🎉                   #"
echo "########################################################################################"