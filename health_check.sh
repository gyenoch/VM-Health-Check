#!/bin/bash
# =============================================
# VM Health Check Script
# ---------------------------------------------
# Author: Enoch Gyampoh
# Description: Checks CPU, Memory, Disk usage, and Load average.
# Usage:
#   ./health_check.sh         → Displays concise health status
#   ./health_check.sh explain → Displays detailed explanation
# =============================================

# Define thresholds (customize as needed)
CPU_THRESHOLD=80
MEM_THRESHOLD=80
DISK_THRESHOLD=80

# Get system metrics
cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8}')
mem_usage=$(free | awk '/Mem/{printf("%.2f"), $3/$2*100}')
disk_usage=$(df / | awk 'END{print $5}' | tr -d '%')
load_avg=$(uptime | awk -F'load average:' '{print $2}' | cut -d',' -f1 | xargs)

# Function to check health status
check_health() {
    local status="Healthy"

    if (( ${cpu_usage%.*} > CPU_THRESHOLD )); then
        status="Unhealthy"
    fi

    if (( ${mem_usage%.*} > MEM_THRESHOLD )); then
        status="Unhealthy"
    fi

    if (( ${disk_usage%.*} > DISK_THRESHOLD )); then
        status="Unhealthy"
    fi

    echo "$status"
}

# Function to display brief summary
brief_summary() {
    echo "===== VM Health Summary ====="
    echo "CPU Usage:  ${cpu_usage}%"
    echo "Memory Usage: ${mem_usage}%"
    echo "Disk Usage:  ${disk_usage}%"
    echo "Load Average: ${load_avg}"
    echo "-----------------------------"
    echo "Overall Health: $(check_health)"
    echo "==============================="
}

# Function to display detailed explanation
detailed_summary() {
    echo "===== VM Health Detailed Summary ====="
    echo "CPU Usage: ${cpu_usage}%"
    if (( ${cpu_usage%.*} > CPU_THRESHOLD )); then
        echo "⚠️ CPU usage exceeds ${CPU_THRESHOLD}%. Consider closing heavy processes or scaling up."
    else
        echo "✅ CPU usage is within healthy limits."
    fi

    echo
    echo "Memory Usage: ${mem_usage}%"
    if (( ${mem_usage%.*} > MEM_THRESHOLD )); then
        echo "⚠️ Memory usage exceeds ${MEM_THRESHOLD}%. Consider freeing memory or upgrading RAM."
    else
        echo "✅ Memory usage is within healthy limits."
    fi

    echo
    echo "Disk Usage: ${disk_usage}%"
    if (( ${disk_usage%.*} > DISK_THRESHOLD )); then
        echo "⚠️ Disk usage exceeds ${DISK_THRESHOLD}%. Consider cleaning up unnecessary files."
    else
        echo "✅ Disk usage is within healthy limits."
    fi

    echo
    echo "Load Average (1 min): ${load_avg}"
    echo "✅ Load average gives an overview of CPU load in the last minute."
    echo
    echo "Overall Health Status: $(check_health)"
    echo "========================================"
}

# Main execution
if [[ "$1" == "explain" ]]; then
    detailed_summary
else
    brief_summary
fi

