#!/bin/bash

echo "⏳🚀 Step 2: Installing dependencies..."

echo "⏳🚀 Updating repository..."
sudo apt update -y
echo "✅ Done!"

echo "⏳🚀 Installing dependencies..."
sudo apt install curl jq git -y
echo "✅ Done!"

echo "✅ Installing dependencies Complete!"
echo "_____________________________________________________________"