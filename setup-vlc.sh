#!/bin/bash
# Cài VLC bản apt (native) và set làm ứng dụng mặc định cho video
# Lưu ý: KHÔNG dùng snap VLC vì bị lỗi trên GNOME 47+/Wayland

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

info()    { echo -e "${GREEN}[✓]${NC} $1"; }
warning() { echo -e "${YELLOW}[!]${NC} $1"; }

echo "================================================"
echo "   VLC Setup"
echo "================================================"
echo ""

# --- Gỡ snap VLC nếu đang cài (bị lỗi trên Wayland/GNOME 47+) ---
if snap list vlc &>/dev/null 2>&1; then
    warning "Phát hiện snap VLC — gỡ để tránh lỗi Wayland..."
    sudo snap remove vlc
    info "Đã gỡ snap VLC"
fi

# --- Gỡ flatpak VLC nếu đang cài (khởi động chậm) ---
if flatpak list 2>/dev/null | grep -q "org.videolan.VLC"; then
    warning "Phát hiện flatpak VLC — gỡ để dùng bản apt nhanh hơn..."
    flatpak uninstall --user org.videolan.VLC -y 2>/dev/null || true
    rm -f ~/.local/share/applications/org.videolan.VLC.desktop
    info "Đã gỡ flatpak VLC"
fi

# --- Cài VLC qua apt ---
echo "[1/2] Cài VLC..."
sudo apt update -qq
sudo apt install -y vlc
info "VLC $(vlc --version 2>/dev/null | head -1 | awk '{print $3}') đã cài"

# --- Set làm ứng dụng mặc định ---
echo ""
echo "[2/2] Set VLC làm ứng dụng mặc định cho video..."

VIDEO_TYPES=(
    video/mp4
    video/x-matroska
    video/avi
    video/quicktime
    video/x-msvideo
    video/mpeg
    video/webm
    video/3gpp
    video/flv
    video/x-flv
    video/x-ms-wmv
    video/mp2t
)

for mime in "${VIDEO_TYPES[@]}"; do
    xdg-mime default vlc.desktop "$mime"
done

update-desktop-database ~/.local/share/applications/ 2>/dev/null || true
info "Đã set mặc định cho ${#VIDEO_TYPES[@]} định dạng video"

echo ""
echo "================================================"
echo "  Hoàn tất! Double-click file video là mở VLC."
echo "================================================"
