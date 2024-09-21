#!/bin/bash

echo "##########################################################################################"
echo "#                     ⏳ STEP 1: SETTING UP NETWORK CONFIGURATION 🚀                     #"
echo "##########################################################################################"

IP_ADDRESS=$1
NETMASK=$2
GATEWAY=$3

sudo tee -a /etc/network/interfaces << EOF

auto eth1
iface eth1 inet static
    address $IP_ADDRESS
    netmask $NETMASK
    post-up ip route del default || true
    post-up ip route add default via $GATEWAY dev \$IFACE
EOF

sudo cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.ipv4.ip_forward = 1
EOF

sudo systemctl restart networking
sudo sysctl --system

sudo sed -i.bak '/swap/s/^/#/' /etc/fstab
sudo swapoff -a

echo "##########################################################################################"
echo "#                  ✅ NETWORK CONFIGURATION COMPLETED SUCCESSFULLY! 🎉                   #"
echo "##########################################################################################"
