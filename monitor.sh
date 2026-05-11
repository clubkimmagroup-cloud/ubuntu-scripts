#!/bin/bash
# Real-time system monitor (refreshes every 2 seconds)
# Press Ctrl+C to exit

INTERVAL=${1:-2}

while true; do
    clear
    echo "=== System Monitor — $(date '+%Y-%m-%d %H:%M:%S') === (Ctrl+C to quit)"

    echo -e "\n[ CPU Load ]"
    top -bn1 | grep "Cpu(s)" | awk '{print "  User: "$2"  System: "$4"  Idle: "$8}'

    echo -e "\n[ Memory ]"
    free -h | awk 'NR==2{printf "  Used: %s / %s (%.0f%%)\n", $3,$2,$3/$2*100}'

    echo -e "\n[ Disk ]"
    df -h | grep -vE "tmpfs|loop|udev" | awk 'NR>1{printf "  %-20s %s used of %s (%s)\n",$6,$3,$2,$5}'

    echo -e "\n[ Top 5 Processes ]"
    ps aux --sort=-%cpu | awk 'NR>1 && NR<=6 {printf "  %-20s CPU: %s%%  MEM: %s%%\n", $11, $3, $4}'

    sleep "$INTERVAL"
done
