#!/bin/bash
# Cài n8n workflow automation bằng Docker (snap)
# Truy cập sau khi cài: http://localhost:5678
# Test trên: Ubuntu 26.04 LTS (Resolute)

set -e

N8N_DIR="$HOME/tools/n8n"

echo "=== [1/4] Cài Docker ==="
if ! command -v docker &>/dev/null; then
    echo "Cài Docker qua snap..."
    sudo snap install docker
    echo "Thêm user vào group docker..."
    sudo groupadd docker 2>/dev/null || true
    sudo usermod -aG docker "$USER"
    echo ""
    echo "QUAN TRỌNG: Cần logout và login lại để group docker có hiệu lực."
    echo "Sau khi login lại, chạy lại script này để tiếp tục."
    exit 0
fi
docker --version

echo "=== [2/4] Tạo thư mục và cấu hình ==="
mkdir -p "$N8N_DIR"

cat > "$N8N_DIR/docker-compose.yml" << 'EOF'
services:
  n8n:
    image: n8nio/n8n
    restart: unless-stopped
    ports:
      - "5678:5678"
    environment:
      - N8N_HOST=localhost
      - N8N_PORT=5678
      - N8N_PROTOCOL=http
      - WEBHOOK_URL=http://localhost:5678/
      - GENERIC_TIMEZONE=Asia/Ho_Chi_Minh
    volumes:
      - n8n_data:/home/node/.n8n
volumes:
  n8n_data:
EOF

cat > "$N8N_DIR/manage.sh" << 'EOF'
#!/bin/bash
DOCKER="docker"
if ! docker info &>/dev/null 2>&1; then
  DOCKER="sudo docker"
fi
case "$1" in
  start) cd ~/tools/n8n && $DOCKER compose up -d ;;
  stop)  cd ~/tools/n8n && $DOCKER compose down ;;
  logs)  cd ~/tools/n8n && $DOCKER compose logs -f ;;
  *)     echo "Usage: n8n-manage {start|stop|logs}" ;;
esac
EOF
chmod +x "$N8N_DIR/manage.sh"

echo "=== [3/4] Khởi động n8n ==="
DOCKER_CMD="docker"
if ! docker info &>/dev/null 2>&1; then
    DOCKER_CMD="sudo docker"
fi
cd "$N8N_DIR" && $DOCKER_CMD compose up -d

echo "=== [4/4] Thêm alias vào ~/.bashrc ==="
if ! grep -q "alias n8n-manage=" ~/.bashrc; then
    echo "alias n8n-manage='~/tools/n8n/manage.sh'" >> ~/.bashrc
fi

echo ""
echo "=== HOÀN THÀNH ==="
echo "n8n đang chạy tại: http://localhost:5678"
echo ""
echo "Quản lý:"
echo "  source ~/.bashrc"
echo "  n8n-manage start   # Khởi động"
echo "  n8n-manage stop    # Dừng"
echo "  n8n-manage logs    # Xem logs"
