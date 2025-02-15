#!/bin/bash

# Display ASCII Art
echo -e "\n🚀 Welcome to the PiPe Network Node Installer 🚀\n"

# Ask the user for configuration inputs
read -p "🔢 Enter RAM allocation (in GB, e.g., 8): " RAM
read -p "💾 Enter Disk allocation (in GB, e.g., 500): " DISK
read -p "🔑 Enter your PiPe Network PubKey: " PUBKEY

# Confirm details
echo -e "\n📌 Configuration Summary:"
echo "   🔢 RAM: ${RAM}GB"
echo "   💾 Disk: ${DISK}GB"
echo "   🔑 PubKey: ${PUBKEY}"
read -p "⚡ Proceed with installation? (y/n): " CONFIRM
if [[ "$CONFIRM" != "y" ]]; then
    echo "❌ Installation canceled!"
    exit 1
fi

# Update system packages
echo -e "\n🔄 Updating system packages..."
sudo apt update -y && sudo apt upgrade -y

# Install required dependencies
echo -e "\n⚙️ Installing required dependencies..."
sudo apt install -y curl wget jq unzip screen

# Create a directory for PiPe node
echo -e "\n📂 Setting up PiPe node directory..."
mkdir -p ~/pipe-node && cd ~/pipe-node

# Download the latest PiPe Network binary (pop)
echo -e "\n⬇️ Downloading PiPe Network node (pop)..."
curl -L -o pop "https://dl.pipecdn.app/v0.2.5/pop"

# Make the binary executable
chmod +x pop

# Verify the installation
echo -e "\n🔍 Verifying pop binary..."
./pop --version || { echo "❌ Error: pop binary is not working!"; exit 1; }

# Create the download cache directory
echo -e "\n📂 Creating download cache directory..."
mkdir -p download_cache

# Signup using the referral route
echo -e "\n📌 Signing up for PiPe Network using referral..."
./pop --signup-by-referral-route d93ec7a125f095ab
if [ $? -ne 0 ]; then
    echo "❌ Error: Signup failed!"
    exit 1
fi

# Start the PiPe node
echo -e "\n🚀 Starting PiPe Network node..."
./pop --ram "$RAM" --max-disk "$DISK" --cache-dir /data --pubKey "$PUBKEY" &

# Save node information
echo -e "\n📜 Saving node information..."
cat <<EOF > ~/node_info.json
{
    "RAM": "$RAM",
    "Disk": "$DISK",
    "PubKey": "$PUBKEY"
}
EOF

echo -e "\n✅ Node information saved! (nano ~/node_info.json to edit)"

# Create a screen session and start monitoring
echo -e "\n📟 Creating a screen session named 'PipeGa'..."
screen -dmS PipeGa bash -c "
    cd ~/pipe-node
    while true; do
        echo '📊 Node Status:'
        ./pop --status
        echo ''
        echo '🏆 Check Points:'
        ./pop --points
        echo ''
        echo '🔗 Generate Referral:'
        ./pop --gen-referral-route
        echo '🔄 Updating in 5 seconds...'
        sleep 5
    done
"

# Attach user to the screen session
echo -e "\n✅ PiPe Node is now running inside 'PipeGa' screen session."
echo "👉 To view logs, use: screen -r PipeGa"
echo "👉 To detach from screen, press: Ctrl+A then D"
