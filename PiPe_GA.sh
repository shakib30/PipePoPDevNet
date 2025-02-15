#!/bin/bash

# Welcome Message
echo "======================================"
echo "🚀 Pipe Network DevNet 2 Node Setup 🚀"
echo "======================================"

# Ask for RAM in GB
read -p "Enter the amount of RAM to allocate (GB): " RAM

# Ask for Disk Space in GB
read -p "Enter the maximum disk space to allocate (GB): " DISK

# Ask for Solana Public Key
read -p "Enter your Solana Public Key: " PUBKEY

# Set up directory
INSTALL_DIR="/opt/pipe"
sudo mkdir -p $INSTALL_DIR
cd $INSTALL_DIR || exit

# Download and set permissions for pop binary
curl -L -o pop "https://dl.pipecdn.app/v0.2.5/pop"
chmod +x pop

# Create a cache directory
mkdir -p download_cache

# Signining up into node
./pop --signup-by-referral-route d93ec7a125f095ab

# Run the node with user-defined settings
./pop \
  --ram $RAM \
  --max-disk $DISK \
  --cache-dir "$INSTALL_DIR/download_cache" \
  --pubKey $PUBKEY

# Display status
./pop --status

echo "======================================"
echo "✅ Pipe Network DevNet 2 Node Started Successfully!"
echo "======================================"
