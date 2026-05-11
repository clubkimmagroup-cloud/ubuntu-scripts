#!/bin/bash
# Install essential tools for development and system administration

set -e

PACKAGES=(
    # System tools
    curl wget git htop neofetch tree unzip
    # Network tools
    net-tools nmap openssh-server ufw
    # Dev tools
    build-essential python3 python3-pip nodejs npm
    # File management
    rsync ncdu ranger
    # Text editors
    vim nano
)

echo "=== Installing essential packages ==="
sudo apt update
sudo apt install -y "${PACKAGES[@]}"

echo "=== Enabling SSH service ==="
sudo systemctl enable ssh --now

echo "=== Done ==="
echo "Installed: ${PACKAGES[*]}"
