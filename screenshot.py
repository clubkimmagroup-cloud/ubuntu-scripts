#!/home/may3/tools/browser-use/.venv/bin/python
"""
Dùng: python3 screenshot.py <url> [output_dir]
Ví dụ: python3 screenshot.py class.kimma.group ~/autowf
"""
import sys
import os
from datetime import datetime
from playwright.sync_api import sync_playwright

def screenshot(url, output_dir):
    if not url.startswith("http"):
        url = "https://" + url

    os.makedirs(output_dir, exist_ok=True)

    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    domain = url.replace("https://","").replace("http://","").replace("/","_")
    filename = f"{domain}_{timestamp}.png"
    filepath = os.path.join(output_dir, filename)

    print(f"Đang mở: {url}")

    with sync_playwright() as p:
        browser = p.chromium.launch(
            headless=False,
            args=["--no-sandbox", "--disable-dev-shm-usage"]
        )
        page = browser.new_page(viewport={"width": 1366, "height": 768})

        page.goto(url, wait_until="networkidle", timeout=30000)
        page.wait_for_timeout(2000)

        page.screenshot(path=filepath, full_page=True)
        browser.close()

    print(f"✅ Đã lưu: {filepath}")
    return filepath

if __name__ == "__main__":
    url = sys.argv[1] if len(sys.argv) > 1 else "class.kimma.group"
    output_dir = sys.argv[2] if len(sys.argv) > 2 else os.path.expanduser("~/autowf")
    screenshot(url, output_dir)
