#!/bin/bash
# Clean up disk space: temp files, logs, apt cache, old kernels

set -e

echo "=== Before ==="
df -h /

echo "--- APT cache ---"
sudo apt autoclean
sudo apt autoremove -y

echo "--- Journal logs (keep last 7 days) ---"
sudo journalctl --vacuum-time=7d

echo "--- Temp files ---"
sudo rm -rf /tmp/* /var/tmp/* 2>/dev/null || true

echo "--- Old snap revisions ---"
snap list --all | awk '/disabled/{print $1, $3}' | while read name rev; do
    sudo snap remove "$name" --revision="$rev" 2>/dev/null || true
done

echo "--- Thumbnail cache ---"
rm -rf ~/.cache/thumbnails/* 2>/dev/null || true

echo "=== After ==="
df -h /
