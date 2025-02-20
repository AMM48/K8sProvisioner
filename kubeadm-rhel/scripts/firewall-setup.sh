#!/bin/bash

echo "##########################################################################################"
echo "#                          ⏳ STEP 5: OPENING REQUIRED PORTS 🚀                          #"
echo "##########################################################################################"

NODE=$1

sudo firewall-cmd --add-port=10250/tcp --add-port=8472/udp --add-port=53/udp \
 --add-port=53/tcp --add-port=4240/tcp --add-port=30000-32767/tcp --permanent

if [[ $NODE == "control-plane" ]]; then
    sudo firewall-cmd --add-port=6443/tcp --add-port=2379-2380/tcp \
    --add-port=10259/tcp --add-port=10257/tcp --permanent
fi

sudo firewall-cmd --reload

echo "##########################################################################################"
echo "#                        ✅ REQUIRED PORTS OPENED SUCCESSFULLY! 🎉                       #"
echo "##########################################################################################"