#!/bin/bash
# Configure UFW firewall with sensible defaults

set -e

echo "=== Setting up UFW Firewall ==="

sudo ufw default deny incoming
sudo ufw default allow outgoing

# Allow SSH (always keep this to avoid lockout)
sudo ufw allow ssh

# Uncomment to allow other services:
# sudo ufw allow 80/tcp    # HTTP
# sudo ufw allow 443/tcp   # HTTPS
# sudo ufw allow 3306/tcp  # MySQL (restrict to specific IP in production)

sudo ufw --force enable
sudo ufw status verbose
