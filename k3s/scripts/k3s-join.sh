#!/bin/bash

echo "###########################################################################################"
echo "#                    ⏳ STEP 3: JOINING WORKER NODES TO THE CLUSTER 🚀                    #"
echo "###########################################################################################"

IP_ADDRESS=$1

source /vagrant/k3s-token.sh

curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="agent --node-ip=$IP_ADDRESS" K3S_URL=https://$NODE_IP:6443 K3S_TOKEN=$K3S_TOKEN sh -s -

echo "########################################################################################"
echo "#                  ✅ WORKER NODES JOINED THE CLUSTER SUCCESSFULLY 🎉                  #"
echo "########################################################################################"