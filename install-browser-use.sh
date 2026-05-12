#!/bin/bash
# Cài browser-use: điều khiển trình duyệt bằng AI (langchain-anthropic + playwright)
# Yêu cầu: Python 3.10+, ANTHROPIC_API_KEY đã được set
# Test trên: Ubuntu 24.04, 26.04 LTS
#
# Workaround Ubuntu 26.04+: dùng PLAYWRIGHT_HOST_PLATFORM_OVERRIDE=ubuntu24.04-x64
# để tải Chromium (binary tương thích, Playwright chưa hỗ trợ chính thức 26.04)

set -e

TOOLS_DIR="$HOME/tools/browser-use"

echo "=== [1/5] Kiểm tra Python ==="
python3 --version

echo "=== [2/5] Cài uv (nếu chưa có) ==="
if ! command -v uv &>/dev/null && [ ! -f "$HOME/.local/bin/uv" ]; then
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
if uv run playwright install chromium 2>/dev/null; then
    echo "Playwright Chromium cài thành công"
else
    echo "OS chưa được hỗ trợ chính thức, dùng platform override ubuntu24.04-x64..."
    PLAYWRIGHT_HOST_PLATFORM_OVERRIDE=ubuntu24.04-x64 uv run playwright install chromium
fi

echo "=== Tạo script run.py ==="
cat > "$TOOLS_DIR/run.py" << 'PYEOF'
import asyncio, sys
from browser_use import Agent
from langchain_anthropic import ChatAnthropic

async def main():
    task = " ".join(sys.argv[1:]) if len(sys.argv) > 1 else "Go to google.com and return the page title"
    agent = Agent(task=task, llm=ChatAnthropic(model="claude-opus-4-5"))
    result = await agent.run()
    print(result)

asyncio.run(main())
PYEOF

echo "=== Tạo examples/open-n8n.py ==="
cat > "$TOOLS_DIR/examples/open-n8n.py" << 'PYEOF'
import asyncio
from browser_use import Agent
from langchain_anthropic import ChatAnthropic

async def main():
    agent = Agent(
        task="Open http://localhost:5678 and describe the n8n interface",
        llm=ChatAnthropic(model="claude-opus-4-5"),
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
alias browser='cd ~/tools/browser-use && source ~/.local/bin/env && uv run python run.py'
BASHEOF
fi

echo ""
echo "=== HOÀN THÀNH ==="
echo "Cách dùng:"
echo "  source ~/.bashrc"
echo "  browser \"task của bạn\""
echo ""
echo "Lưu ý: đảm bảo ANTHROPIC_API_KEY đã được export trước khi chạy"
