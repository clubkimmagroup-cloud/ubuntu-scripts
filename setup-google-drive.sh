#!/bin/bash
# Tự động cài rclone và mount Google Drive vào ~/GoogleDrive
# Chạy 1 lần trên máy mới, xác thực qua trình duyệt, tự động mount khi khởi động

set -e

RCLONE_REMOTE="gdrive"
MOUNT_DIR="$HOME/GoogleDrive"
RCLONE_BIN="$HOME/.local/bin/rclone"
SERVICE_FILE="$HOME/.config/systemd/user/rclone-gdrive.service"

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

info()    { echo -e "${GREEN}[✓]${NC} $1"; }
warning() { echo -e "${YELLOW}[!]${NC} $1"; }

echo "================================================"
echo "   Google Drive Setup via rclone"
echo "================================================"
echo ""

# --- Bước 1: Cài rclone ---
if command -v rclone &>/dev/null || [ -x "$RCLONE_BIN" ]; then
    info "rclone đã được cài: $(rclone version 2>/dev/null | head -1 || $RCLONE_BIN version | head -1)"
else
    echo "[1/5] Cài rclone..."
    mkdir -p "$HOME/.local/bin"

    if sudo apt install -y rclone &>/dev/null 2>&1; then
        info "Cài rclone qua apt thành công"
    else
        warning "Không dùng được sudo, tải rclone binary về ~/.local/bin..."
        TMP=$(mktemp -d)
        curl -fsSL "https://downloads.rclone.org/rclone-current-linux-amd64.zip" -o "$TMP/rclone.zip"
        unzip -q "$TMP/rclone.zip" -d "$TMP/extract"
        cp "$TMP/extract/rclone-"*"-linux-amd64/rclone" "$RCLONE_BIN"
        chmod +x "$RCLONE_BIN"
        rm -rf "$TMP"
        info "rclone đã cài vào $RCLONE_BIN"
    fi
fi

# Đảm bảo rclone tìm được trong PATH
RCLONE_CMD=$(command -v rclone 2>/dev/null || echo "$RCLONE_BIN")

# Thêm ~/.local/bin vào PATH nếu chưa có
if ! echo "$PATH" | grep -q "$HOME/.local/bin"; then
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc"
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.profile"
    export PATH="$HOME/.local/bin:$PATH"
    info "Đã thêm ~/.local/bin vào PATH"
fi

# --- Bước 2: Xác thực Google Drive ---
echo ""
if $RCLONE_CMD listremotes 2>/dev/null | grep -q "^${RCLONE_REMOTE}:"; then
    info "Remote '$RCLONE_REMOTE' đã được cấu hình, bỏ qua bước xác thực"
else
    echo "[2/5] Xác thực Google Drive..."
    echo ""
    warning "Trình duyệt sẽ mở ra để đăng nhập Google."
    warning "Hãy đăng nhập và cho phép quyền truy cập, sau đó quay lại terminal."
    echo ""
    read -p "Nhấn Enter để mở trình duyệt xác thực..." _

    $RCLONE_CMD config create "$RCLONE_REMOTE" drive scope=drive
    info "Xác thực Google Drive thành công"
fi

# --- Bước 3: Tạo thư mục mount ---
echo ""
echo "[3/5] Chuẩn bị thư mục mount..."
mkdir -p "$MOUNT_DIR"
info "Thư mục mount: $MOUNT_DIR"

# --- Bước 4: Tạo systemd user service ---
echo ""
echo "[4/5] Cài đặt auto-mount khi khởi động..."
mkdir -p "$(dirname "$SERVICE_FILE")"

cat > "$SERVICE_FILE" << EOF
[Unit]
Description=rclone Google Drive mount
After=network-online.target
Wants=network-online.target

[Service]
Type=notify
ExecStart=${RCLONE_CMD} mount ${RCLONE_REMOTE}: ${MOUNT_DIR} \\
  --vfs-cache-mode writes \\
  --log-level INFO
ExecStop=/bin/fusermount -u ${MOUNT_DIR}
Restart=on-failure
RestartSec=10

[Install]
WantedBy=default.target
EOF

systemctl --user daemon-reload
systemctl --user enable rclone-gdrive.service
info "Service auto-mount đã bật"

# --- Bước 5: Mount ngay ---
echo ""
echo "[5/5] Mount Google Drive..."

# Unmount nếu đang mount rồi
fusermount -u "$MOUNT_DIR" 2>/dev/null || true

systemctl --user start rclone-gdrive.service 2>/dev/null || \
    $RCLONE_CMD mount "$RCLONE_REMOTE": "$MOUNT_DIR" --vfs-cache-mode writes --daemon

sleep 2

if mountpoint -q "$MOUNT_DIR"; then
    info "Google Drive đã mount vào $MOUNT_DIR"
    echo ""
    echo "Nội dung Drive:"
    ls "$MOUNT_DIR" | head -10
else
    warning "Mount chưa hoàn tất, thử lại bằng lệnh:"
    echo "  systemctl --user start rclone-gdrive.service"
fi

echo ""
echo "================================================"
echo "  Hoàn tất! Google Drive có tại: $MOUNT_DIR"
echo "  Tự động mount mỗi lần đăng nhập Ubuntu."
echo "================================================"
