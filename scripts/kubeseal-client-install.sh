#!/bin/bash

echo "⏳🚀 Step 5: Installing Kubeseal client..."

echo "⏳🚀 Fetching latest Kubeseal version"
KUBESEAL_VERSION=$(curl -s https://api.github.com/repos/bitnami-labs/sealed-secrets/tags | jq -r '.[0].name' | cut -c 2-)
echo "✅ Done!"

if [ -z "$KUBESEAL_VERSION" ]; then
    echo "Failed to fetch the latest KUBESEAL_VERSION"
    exit 1
fi

echo "⏳🚀 Dowmloading latest Kubeseal package"
curl -OL "https://github.com/bitnami-labs/sealed-secrets/releases/download/v${KUBESEAL_VERSION}/kubeseal-${KUBESEAL_VERSION}-linux-amd64.tar.gz"
echo "✅ Done!"

echo "⏳🚀 Uncompressing Kubeseal package"
tar -xvzf kubeseal-${KUBESEAL_VERSION}-linux-amd64.tar.gz kubeseal
echo "✅ Done!"

echo "⏳🚀 Installing Kubeseal client"
sudo install -m 755 kubeseal /usr/local/bin/kubeseal
echo "✅ Done!"

echo "⏳🚀 Deleting unwanted Kubeseal files"
rm kubeseal kubeseal-${KUBESEAL_VERSION}-linux-amd64.tar.gz
echo "✅ Done!"

echo "✅ Installing Kubeseal client Complete!"
echo "_____________________________________________________________"