#!/bin/bash

# ==========================
# Configuration
# ==========================
CPU_THRESHOLD=80
MEMORY_THRESHOLD=80
DISK_THRESHOLD=80
PROCESS_THRESHOLD=300

LOG_FILE="/var/log/system_health.log"

# Function to log alerts
log_alert() {
    local message="$1"
    echo "[ALERT] $(date '+%Y-%m-%d %H:%M:%S') - $message"
    echo "[ALERT] $(date '+%Y-%m-%d %H:%M:%S') - $message" >> "$LOG_FILE"
}

# Check CPU usage
cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8}')
cpu_usage=${cpu_usage%.*}  # convert to integer
if [ "$cpu_usage" -gt "$CPU_THRESHOLD" ]; then
    log_alert "High CPU usage detected: ${cpu_usage}%"
fi

# Check memory usage
mem_usage=$(free | awk '/Mem/ {printf("%.0f"), $3/$2 * 100}')
if [ "$mem_usage" -gt "$MEMORY_THRESHOLD" ]; then
    log_alert "High Memory usage detected: ${mem_usage}%"
fi

# Check disk usage (/ partition)
disk_usage=$(df / | awk 'NR==2 {print $5}' | sed 's/%//')
if [ "$disk_usage" -gt "$DISK_THRESHOLD" ]; then
    log_alert "High Disk usage detected: ${disk_usage}%"
fi

# Check number of processes
proc_count=$(ps -e --no-headers | wc -l)
if [ "$proc_count" -gt "$PROCESS_THRESHOLD" ]; then
    log_alert "High number of processes detected: ${proc_count}"
fi

# Print current stats
echo "===== System Health Report ====="
echo "CPU Usage: ${cpu_usage}%"
echo "Memory Usage: ${mem_usage}%"
echo "Disk Usage: ${disk_usage}%"
echo "Running Processes: ${proc_count}"
