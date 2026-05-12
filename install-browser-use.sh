#!/bin/bash
# Cài browser-use: điều khiển trình duyệt bằng AI (langchain-anthropic + playwright)
# Yêu cầu: Python 3.10+, ANTHROPIC_API_KEY đã được set
# Test trên: Ubuntu 26.04 LTS (Resolute)

set -e

TOOLS_DIR="$HOME/tools/browser-use"
UV_BIN="$HOME/.local/bin/uv"

echo "=== [1/5] Kiểm tra Python ==="
python3 --version

echo "=== [2/5] Cài uv (nếu chưa có) ==="
if ! command -v uv &>/dev/null && [ ! -f "$UV_BIN" ]; then
    curl -LsSf https://astral.sh/uv/install.sh | sh
fi
source "$HOME/.local/bin/env" 2>/dev/null || true
export PATH="$HOME/.local/bin:$PATH"
uv --version

echo "=== [3/5] Tạo thư mục và môi trường ảo ==="
mkdir -p "$TOOLS_DIR/examples"
cd "$TOOLS_DIR"
uv venv

echo "=== [4/5] Cài packages ==="
uv pip install browser-use langchain-anthropic playwright

echo "=== [5/5] Cài Chromium cho Playwright ==="
# Ubuntu 24.04 trở xuống: playwright tự tải chromium
# Ubuntu 26.04+: dùng chromium từ snap (playwright chưa hỗ trợ chính thức)
if uv run playwright install chromium 2>/dev/null; then
    CHROMIUM_PATH=""
    echo "Playwright chromium cài thành công"
else
    echo "Playwright chưa hỗ trợ Ubuntu phiên bản này, dùng snap chromium..."
    if ! command -v chromium &>/dev/null && ! command -v chromium-browser &>/dev/null; then
        sudo snap install chromium
    fi
    CHROMIUM_PATH="/snap/bin/chromium"
    echo "Dùng chromium tại: $CHROMIUM_PATH"
fi

echo "=== Tạo script run.py ==="
cat > "$TOOLS_DIR/run.py" << 'PYEOF'
import asyncio, sys, os
from browser_use import Agent, Browser, BrowserConfig
from langchain_anthropic import ChatAnthropic

async def main():
    task = " ".join(sys.argv[1:]) if len(sys.argv) > 1 else "Go to google.com and return the page title"
    chromium_path = os.environ.get("CHROMIUM_PATH", "")
    if chromium_path:
        browser = Browser(config=BrowserConfig(chrome_instance_path=chromium_path))
        agent = Agent(task=task, llm=ChatAnthropic(model="claude-opus-4-5"), browser=browser)
    else:
        agent = Agent(task=task, llm=ChatAnthropic(model="claude-opus-4-5"))
    result = await agent.run()
    print(result)

asyncio.run(main())
PYEOF

echo "=== Tạo examples/open-n8n.py ==="
cat > "$TOOLS_DIR/examples/open-n8n.py" << 'PYEOF'
import asyncio, os
from browser_use import Agent, Browser, BrowserConfig
from langchain_anthropic import ChatAnthropic

async def main():
    chromium_path = os.environ.get("CHROMIUM_PATH", "")
    kwargs = {}
    if chromium_path:
        kwargs["browser"] = Browser(config=BrowserConfig(chrome_instance_path=chromium_path))
    agent = Agent(
        task="Open http://localhost:5678 and describe the n8n interface",
        llm=ChatAnthropic(model="claude-opus-4-5"),
        **kwargs,
    )
    result = await agent.run()
    print(result)

asyncio.run(main())
PYEOF

echo "=== Thêm alias vào ~/.bashrc ==="
if ! grep -q "alias browser=" ~/.bashrc; then
    cat >> ~/.bashrc << 'BASHEOF'

# browser-use AI tool
export PATH="$HOME/.local/bin:$PATH"
alias browser='CHROMIUM_PATH=/snap/bin/chromium cd ~/tools/browser-use && source ~/.local/bin/env && uv run python run.py'
BASHEOF
fi

echo ""
echo "=== HOÀN THÀNH ==="
echo "Cách dùng:"
echo "  source ~/.bashrc"
if [ -n "$CHROMIUM_PATH" ]; then
    echo "  CHROMIUM_PATH=$CHROMIUM_PATH cd ~/tools/browser-use && uv run python run.py \"task của bạn\""
else
    echo "  cd ~/tools/browser-use && uv run python run.py \"task của bạn\""
fi
echo ""
echo "Lưu ý: đảm bảo ANTHROPIC_API_KEY đã được export trước khi chạy"
