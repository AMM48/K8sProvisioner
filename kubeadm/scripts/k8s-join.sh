#!/bin/bash

echo "###########################################################################################"
echo "#                    ⏳ STEP 5: JOINING WORKER NODES TO THE CLUSTER 🚀                    #"
echo "###########################################################################################"

source /vagrant/scripts/common.sh
source /vagrant/token.sh

retries "sudo $TOKEN" "Failed to join cluster."

echo "########################################################################################"
echo "#                  ✅ WORKER NODES JOINED THE CLUSTER SUCCESSFULLY 🎉                  #"
echo "########################################################################################"