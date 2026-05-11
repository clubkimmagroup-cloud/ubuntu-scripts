#!/bin/bash
# Auto-mount NTFS drive (ổ D/DATA) on Ubuntu
# Ref: huong-dan-mount-o-ntfs-ubuntu.md

set -e

DEVICE="${1:-/dev/nvme0n1p4}"
MOUNT_POINT="/mnt/data"
MEDIA_POINT="/media/$USER/DATA"

echo "=== Cài driver NTFS ==="
sudo apt update -qq
sudo apt install -y ntfs-3g

echo "=== Kiểm tra ổ ==="
lsblk -f "$DEVICE" 2>/dev/null || { echo "Không tìm thấy $DEVICE"; lsblk -f; exit 1; }

UUID=$(sudo blkid -s UUID -o value "$DEVICE")
echo "Device: $DEVICE  |  UUID: $UUID"

# Fix nếu Windows hibernate chưa tắt hẳn
if sudo ntfs-3g "$DEVICE" "$MOUNT_POINT" --test-disk-format 2>&1 | grep -q "hibernat"; then
    echo "Phát hiện Windows hibernate — đang fix..."
    sudo ntfsfix "$DEVICE"
fi

echo "=== Mount thủ công ==="
sudo mkdir -p "$MOUNT_POINT"
sudo umount "$MOUNT_POINT" 2>/dev/null || true
sudo mount -t ntfs-3g -o uid=1000,gid=1000,umask=022 "$DEVICE" "$MOUNT_POINT"
echo "Đã mount: $DEVICE → $MOUNT_POINT"

echo "=== Hiện trong Files (Nautilus) ==="
sudo mkdir -p "$MEDIA_POINT"
sudo umount "$MEDIA_POINT" 2>/dev/null || true
sudo mount --bind "$MOUNT_POINT" "$MEDIA_POINT"
echo "Đã bind: $MOUNT_POINT → $MEDIA_POINT"

echo "=== Thêm vào /etc/fstab (tự mount khi khởi động) ==="
FSTAB_LINE1="UUID=$UUID $MOUNT_POINT ntfs-3g defaults,uid=1000,gid=1000,umask=022 0 0"
FSTAB_LINE2="$MOUNT_POINT $MEDIA_POINT none bind 0 0"

if grep -q "$UUID" /etc/fstab; then
    echo "fstab đã có entry này, bỏ qua."
else
    echo "$FSTAB_LINE1" | sudo tee -a /etc/fstab
    echo "$FSTAB_LINE2" | sudo tee -a /etc/fstab
    echo "Đã thêm vào fstab."
fi

echo "=== Kiểm tra fstab ==="
sudo mount -a
echo "Done. Ổ $DEVICE đã mount tại $MEDIA_POINT"
