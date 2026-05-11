#!/bin/bash
# Display detailed system information

echo "=============================="
echo "  SYSTEM INFORMATION REPORT"
echo "  $(date)"
echo "=============================="

echo -e "\n--- OS ---"
lsb_release -a 2>/dev/null

echo -e "\n--- Kernel ---"
uname -r

echo -e "\n--- CPU ---"
grep -m1 "model name" /proc/cpuinfo | cut -d: -f2 | xargs
echo "Cores: $(nproc)"
echo "Load: $(cut -d' ' -f1-3 /proc/loadavg)"

echo -e "\n--- Memory ---"
free -h

echo -e "\n--- Disk ---"
df -h --total | grep -v "tmpfs\|loop\|udev"

echo -e "\n--- Top Processes (CPU) ---"
ps aux --sort=-%cpu | head -6

echo -e "\n--- Network Interfaces ---"
ip -brief addr show

echo -e "\n--- Uptime ---"
uptime -p
