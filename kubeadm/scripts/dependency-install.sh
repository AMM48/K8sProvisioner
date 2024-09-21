#!/bin/bash

echo "#########################################################################################"
echo "#                         ⏳ STEP 2: INSTALLING DEPENDENCIES 🚀                         #"
echo "#########################################################################################"

source /vagrant/scripts/common.sh

retries "sudo apt -y -qq update" "Failed to update apt repository."
retries "sudo apt -y -qq install apt-transport-https ca-certificates gpg curl jq git" "Failed to install required dependencies."

echo "#########################################################################################"
echo "#                      ✅ DEPENDENCIES INSTALLED SUCCESSFULLY! 🎉                       #"
echo "#########################################################################################"