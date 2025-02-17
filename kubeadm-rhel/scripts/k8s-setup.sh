#!/bin/bash

echo "##########################################################################################"
echo "#             ⏳ STEP 4: CONFIGURING KUBERNETES REPO AND INSTALLING TOOLS 🚀             #"
echo "##########################################################################################"

source /vagrant/scripts/common.sh

sudo sed -i.bak '/swap/s/^/#/' /etc/fstab
sudo swapoff -a

sudo setenforce 0
sudo sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config

cat <<EOF | sudo tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://pkgs.k8s.io/core:/stable:/v1.32/rpm/
enabled=1
gpgcheck=1
gpgkey=https://pkgs.k8s.io/core:/stable:/v1.32/rpm/repodata/repomd.xml.key
exclude=kubelet kubeadm kubectl cri-tools kubernetes-cni
EOF

retries "sudo yum install -y kubelet kubeadm kubectl --disableexcludes=kubernetes" "Failed to install kubernetes tools."

sudo systemctl enable --now kubelet

echo "##########################################################################################"
echo "#           ✅ KUBERNETES REPO CONFIGURED AND TOOLS INSTALLED SUCCESSFULLY! 🎉           #"
echo "##########################################################################################"