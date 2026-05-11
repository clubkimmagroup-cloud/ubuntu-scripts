# Cài Claude Desktop và Claude Code trên Ubuntu 26.04

**Tags:** claude, claude-desktop, claude-code, ubuntu, linux, cài-đặt, snap, npm  
**Áp dụng cho:** Ubuntu 26.04 LTS (Resolute) · GNOME 50 · Wayland  
**Cập nhật:** 2026-05-11

---

## Tóm tắt

Hướng dẫn cài **Claude Desktop** (giao diện chat) và **Claude Code** (AI terminal) trên Ubuntu 26.04. Anthropic chưa có bản Linux chính thức, nhưng cả 2 đều dùng được ổn định qua Snap và npm.

---

## Phần 1 — Claude Desktop (giao diện đồ họa)

### Cài qua Snap (khuyên dùng)

```bash
# Bước 1: Cài curl nếu chưa có
sudo apt install curl -y

# Bước 2: Cài Claude Desktop qua Snap
sudo snap install claude-ai-desktop
```

Sau khi cài xong, nhấn **Super key** → gõ "Claude" → mở app.

> ⚠️ **Lưu ý:** Không dùng repo `pkg.claude-desktop-debian.dev` — repo này chưa hỗ trợ Ubuntu 26.04 (resolute), sẽ báo lỗi 404.

---

## Phần 2 — Claude Code (terminal AI)

### Yêu cầu

- Node.js + npm

### Các bước cài

```bash
# Bước 1: Cài Node.js và npm
sudo apt install nodejs npm -y

# Bước 2: Cài Claude Code (dùng sudo để tránh lỗi permission)
sudo npm install -g @anthropic-ai/claude-code

# Bước 3: Kiểm tra
claude --version
```

> ⚠️ **Lỗi thường gặp:** Nếu chạy `npm install -g` không có `sudo` sẽ báo:  
> `EACCES: permission denied, mkdir '/usr/local/lib/node_modules'`  
> → Thêm `sudo` vào trước là hết.

### Chạy Claude Code

```bash
# Mở terminal, vào thư mục muốn làm việc
cd ~

# Chạy
claude
```

Lần đầu sẽ yêu cầu đăng nhập tài khoản Anthropic — làm theo hướng dẫn trên màn hình.

---

## Phần 3 — Tùy chỉnh Desktop (Dock)

### Gộp top bar + dock thành 1 thanh (Dash to Panel)

```bash
# Cài Extension Manager
sudo apt install gnome-shell-extension-manager -y
```

Mở **Extension Manager** → tìm **"Dash to Panel"** → cài → bật lên → log out và log in lại.

### Ẩn dock mặc định của Ubuntu

Vào **Settings → Ubuntu Desktop → Dock** → tắt toggle **Dock** đi.

---

## Lỗi thường gặp

| Lỗi | Nguyên nhân | Cách fix |
|-----|-------------|----------|
| `curl: command not found` | curl chưa cài | `sudo apt install curl` |
| `EACCES: permission denied` | npm thiếu quyền | Thêm `sudo` vào lệnh npm |
| `claude: command not found` | Gõ nhầm `claude~` | Gõ đúng `claude` (không có `~`) |
| Repo 404 Not Found | Repo không hỗ trợ Ubuntu 26.04 | Dùng Snap thay thế |
| Claude Code báo "Select a repo first" | Chưa chọn thư mục | Chạy `claude` từ terminal thay vì GUI |

---

> Script tự động: `../install-claude.sh`
