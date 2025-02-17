#!/bin/bash

echo "#########################################################################################"
echo "#                         ⏳ STEP 2: INSTALLING DEPENDENCIES 🚀                         #"
echo "#########################################################################################"

source /vagrant/scripts/common.sh

retries "sudo dnf install -y git jq" "Failed to install dependencies"

echo "#########################################################################################"
echo "#                      ✅ DEPENDENCIES INSTALLED SUCCESSFULLY! 🎉                       #"
echo "#########################################################################################"