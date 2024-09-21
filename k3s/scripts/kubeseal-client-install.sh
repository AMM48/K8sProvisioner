#!/bin/bash

echo "##########################################################################################"
echo "#                        ⏳ STEP 5: INSTALLING KUBESEAL CLIENT 🚀                        #"
echo "##########################################################################################"

KUBESEAL_VERSION=$(curl -s https://api.github.com/repos/bitnami-labs/sealed-secrets/tags | jq -r '.[0].name' | cut -c 2-)

if [ -z "$KUBESEAL_VERSION" ]; then
    echo "Failed to fetch the latest KUBESEAL_VERSION"
    exit 1
fi

curl -OL "https://github.com/bitnami-labs/sealed-secrets/releases/download/v${KUBESEAL_VERSION}/kubeseal-${KUBESEAL_VERSION}-linux-amd64.tar.gz"

tar -xvzf kubeseal-${KUBESEAL_VERSION}-linux-amd64.tar.gz kubeseal

sudo install -m 755 kubeseal /usr/local/bin/kubeseal

rm kubeseal kubeseal-${KUBESEAL_VERSION}-linux-amd64.tar.gz

echo "########################################################################################"
echo "#                        ✅ KUBESEAL INSTALLED SUCCESSFULLY! 🎉                        #"
echo "########################################################################################"