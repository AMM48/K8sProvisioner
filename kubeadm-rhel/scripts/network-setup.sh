#!/bin/bash

echo "##########################################################################################"
echo "#                     ⏳ STEP 1: SETTING UP NETWORK CONFIGURATION 🚀                     #"
echo "##########################################################################################"

IP_ADDRESS=$1
CIDR=$2
GATEWAY=$3

# Get NAT Interface and remove it as default route
INTERFACE=$(sudo nmcli -t -f CONNECTION device | awk -F: 'NR==1 {print $1}' | xargs)
sudo nmcli connection modify "$INTERFACE" ipv4.never-default yes
sudo nmcli connection up "$INTERFACE"

# Get the bridge interface and rename it as the device name
INTERFACE=$(sudo nmcli -t -f CONNECTION device | awk -F: 'NR==1 {print $1}' | xargs)
DEVICE=$(sudo nmcli -f DEVICE,CONNECTION device | grep "$INTERFACE" | awk '{print $1}' | xargs)
sudo nmcli connection modify "$INTERFACE" connection.id "$DEVICE"

# Get the Bridge Interface by its new name and configure the Interface
INTERFACE=$(sudo nmcli -t -f CONNECTION device | awk -F: 'NR==1 {print $1}' | xargs)
sudo nmcli connection modify "$INTERFACE" ipv4.addresses "$IP_ADDRESS"/"$CIDR"
sudo nmcli connection modify "$INTERFACE" ipv4.gateway "$GATEWAY"
sudo nmcli connection modify "$INTERFACE" ipv4.dns "8.8.8.8 8.8.4.4"
sudo nmcli connection modify "$INTERFACE" ipv4.method manual
sudo nmcli connection up "$INTERFACE"

# Enable IPv4 Forwarding
sudo cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.ipv4.ip_forward = 1
EOF

sudo sysctl --system

echo "##########################################################################################"
echo "#                  ✅ NETWORK CONFIGURATION COMPLETED SUCCESSFULLY! 🎉                   #"
echo "##########################################################################################"
