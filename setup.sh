#!/bin/bash

# Colors
GREEN='\033[0;32m'
NC='\033[0m' # No Color

clear

# ASCII Art
echo -e "${GREEN}"
echo "██╗  ██╗██╗███╗   ███╗ █████╗ ███╗   ██╗███████╗██╗   ██╗██████╗ ██╗      █████╗ ██╗   ██╗███████╗"
echo "██║  ██║██║████╗ ████║██╔══██╗████╗  ██║██╔════╝██║   ██║██╔══██╗██║     ██╔══██╗██║   ██║██╔════╝"
echo "███████║██║██╔████╔██║███████║██╔██╗ ██║█████╗  ██║   ██║██████╔╝██║     ███████║██║   ██║███████╗"
echo "██╔══██║██║██║╚██╔╝██║██╔══██║██║╚██╗██║██╔══╝  ██║   ██║██╔═══╝ ██║     ██╔══██║██║   ██║╚════██║"
echo "██║  ██║██║██║ ╚═╝ ██║██║  ██║██║ ╚████║███████╗╚██████╔╝██║     ███████╗██║  ██║╚██████╔╝███████║"
echo "╚═╝  ╚═╝╚═╝╚═╝     ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝╚══════╝ ╚═════╝ ╚═╝     ╚══════╝╚═╝  ╚═╝ ╚═════╝ ╚══════╝"
echo -e "${NC}"

echo "🔧 Switching to root user (sudo)..."
sudo su <<EOF

echo "🔄 Updating system packages..."
apt update -y && apt upgrade -y

echo "📁 Creating PufferPanel data directories..."
mkdir -p /var/lib/pufferpanel

echo "📦 Creating Docker volume..."
docker volume create pufferpanel-config

echo "🐳 Setting up PufferPanel container..."
docker create --name pufferpanel \
  -p 8080:8080 -p 5657:5657 \
  -v pufferpanel-config:/etc/pufferpanel \
  -v /var/lib/pufferpanel:/var/lib/pufferpanel \
  -v /var/run/docker.sock:/var/run/docker.sock \
  --restart=on-failure \
  pufferpanel/pufferpanel:latest

echo "▶️ Starting PufferPanel container..."
docker start pufferpanel

echo "👤 Creating PufferPanel admin user (you will be prompted)..."
docker exec -it pufferpanel /pufferpanel/pufferpanel user add

EOF

echo -e "${GREEN}✅ Docker-based PufferPanel installation complete!"
echo -e "Made by HimanshuPlayz${NC}"
