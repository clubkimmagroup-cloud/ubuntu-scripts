# ubuntu-scripts

A collection of automation scripts for Ubuntu system maintenance and setup.

## Scripts

| Script | Mô tả |
|---|---|
| `system-update.sh` | Cập nhật toàn hệ thống (apt + snap + flatpak) và dọn cache |
| `disk-cleanup.sh` | Giải phóng dung lượng: temp, log, apt cache, snap cũ |
| `install-essentials.sh` | Cài bộ công cụ dev/sysadmin cơ bản |
| `setup-firewall.sh` | Cấu hình UFW firewall |
| `system-info.sh` | Báo cáo thông tin hệ thống chi tiết |
| `backup.sh` | Backup thư mục home |
| `create-user.sh` | Tạo user sudo mới |
| `monitor.sh` | Monitor real-time: CPU, RAM, disk, processes |
| `mount-ntfs.sh` | Mount ổ NTFS (dual boot Windows+Ubuntu) tự động |
| `install-claude.sh` | Cài Claude Desktop + Claude Code trên Ubuntu 26.04 |

## Usage

```bash
git clone https://github.com/clubkimmagroup-cloud/ubuntu-scripts
cd ubuntu-scripts
chmod +x *.sh

# Bảo trì hệ thống
./system-update.sh
./disk-cleanup.sh
./system-info.sh
./monitor.sh              # real-time, Ctrl+C để thoát

# Thiết lập môi trường
./install-essentials.sh
./install-claude.sh       # Cài Claude Desktop + Claude Code
./mount-ntfs.sh           # Mount ổ D (NTFS) tự động

# Tiện ích
./backup.sh /media/backup
./create-user.sh newuser
./setup-firewall.sh
```

## Tài liệu (`docs/`)

| File | Nội dung |
|---|---|
| `docs/huong-dan-mount-o-ntfs-ubuntu.md` | Hướng dẫn chi tiết mount ổ NTFS |
| `docs/cai-claude-desktop-claude-code-ubuntu.md` | Hướng dẫn cài Claude trên Ubuntu 26.04 |

## Requirements

- Ubuntu 20.04+ (tested on Ubuntu 26.04 LTS)
- `sudo` privileges for most scripts
