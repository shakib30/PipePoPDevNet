#!/bin/bash

# Banner
echo "🚀 Setting up PiPe Node for DevNet-2 🚀"
echo "======================================"

# Ask user for input
read -p "Enter RAM allocation (e.g., 4G, 8G): " RAM
read -p "Enter Disk space allocation (e.g., 100G, 200G): " DISK
read -p "Enter your Solana Public Key: " PUBKEY

# Install dependencies
echo "🔄 Updating system and installing dependencies..."
sudo apt update && sudo apt install -y curl wget jq unzip

# Create necessary directories
echo "📂 Creating necessary directories..."
mkdir -p ~/pipe-node && cd ~/pipe-node

# Download the `pop` binary
echo "⬇️ Downloading PiPe Network node (pop)..."
wget -O pop https://github.com/pipe-network/pop/releases/latest/download/pop-linux-amd64

# Make it executable
chmod +x pop

# Verify if pop exists
if [[ ! -f "./pop" ]]; then
    echo "❌ Error: pop binary not found! Download might have failed."
    exit 1
fi

# Initialize the node
echo "🚀 Initializing PiPe Node..."
./pop init --ram $RAM --disk $DISK --identity $PUBKEY

# Signing up into node
echo "Signing up into node"
./pop --signup-by-referral-route d93ec7a125f095ab

# Start the node
echo "🚀 Starting PiPe Node..."
./pop start

# Check node status
echo "🔍 Checking node status..."
./pop status

echo "🎉 PiPe Node setup complete!"
