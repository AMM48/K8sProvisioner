#!/bin/bash

echo "⏳🚀 Step 1: Setting up network configuration..."

IP_ADDRESS=$1
NETMASK=$2
GATEWAY=$3

echo "⏳🚀 Setting static IP..."
sudo tee -a /etc/network/interfaces << EOF

auto eth1
iface eth1 inet static
    address $IP_ADDRESS
    netmask $NETMASK
    post-up ip route del default || true
    post-up ip route add default via $GATEWAY dev \$IFACE
EOF
echo "✅ Done!"

echo "⏳🚀 Restart networking service..."
sudo systemctl restart networking
echo "✅ Done!"

echo "✅ Setting up network configuration Complete!"
echo "_____________________________________________________________"
