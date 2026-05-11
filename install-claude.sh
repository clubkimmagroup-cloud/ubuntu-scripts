#!/bin/bash
# Cài Claude Desktop (GUI) và Claude Code (terminal) trên Ubuntu 26.04+
# Ref: [Ubuntu] Cài Claude Desktop + Claude Code trên Ubuntu 26.04

set -e

echo "=== Cài Claude Desktop (Snap) ==="
sudo apt install -y curl
sudo snap install claude-ai-desktop
echo "Claude Desktop đã cài. Tìm trong app launcher (Super → gõ Claude)."

echo ""
echo "=== Cài Claude Code (terminal) ==="

echo "-- Cài Node.js + npm --"
sudo apt install -y nodejs npm

NODE_VER=$(node --version)
NPM_VER=$(npm --version)
echo "Node.js: $NODE_VER  |  npm: $NPM_VER"

echo "-- Cài Claude Code --"
sudo npm install -g @anthropic-ai/claude-code

echo "-- Kiểm tra --"
claude --version

echo ""
echo "=== (Tuỳ chọn) Cài Dash to Panel ==="
read -p "Cài Dash to Panel (gộp dock + top bar)? [y/N] " INSTALL_DASH
if [[ "$INSTALL_DASH" =~ ^[Yy]$ ]]; then
    sudo apt install -y gnome-shell-extension-manager
    echo "Mở Extension Manager → tìm 'Dash to Panel' → cài → bật → log out/in lại."
fi

echo ""
echo "=== Xong! ==="
echo "Chạy Claude Code: mở terminal → gõ 'claude'"
echo "Lần đầu sẽ yêu cầu đăng nhập tài khoản Anthropic."
