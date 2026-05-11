#!/bin/bash
# Full system update, upgrade, and cleanup

set -e

echo "=== System Update ==="
sudo apt update
sudo apt upgrade -y
sudo apt dist-upgrade -y
sudo apt autoremove -y
sudo apt autoclean

echo "=== Snap Update ==="
sudo snap refresh 2>/dev/null || true

echo "=== Flatpak Update ==="
flatpak update -y 2>/dev/null || true

echo "Done. Reboot recommended if kernel was updated."
