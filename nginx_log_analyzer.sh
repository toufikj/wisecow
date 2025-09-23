#!/bin/bash

# ==========================
# Configuration
# ==========================
LOG_FILE="/var/log/nginx/access.log"   # Update if different
REPORT_FILE="/var/log/nginx/log_report.txt"

# ==========================
# Functions
# ==========================

generate_report() {
    echo "===== Nginx Log Analysis Report =====" > "$REPORT_FILE"
    echo "Generated on: $(date)" >> "$REPORT_FILE"
    echo "Log File: $LOG_FILE" >> "$REPORT_FILE"
    echo "=====================================" >> "$REPORT_FILE"
    echo "" >> "$REPORT_FILE"

    # 1. Total number of requests
    total_requests=$(wc -l < "$LOG_FILE")
    echo "Total Requests: $total_requests" >> "$REPORT_FILE"

    # 2. Number of 404 errors
    not_found=$(grep " 404 " "$LOG_FILE" | wc -l)
    echo "Total 404 Errors: $not_found" >> "$REPORT_FILE"

    # 3. Most requested pages (Top 10)
    echo "" >> "$REPORT_FILE"
    echo "Top 10 Requested Pages:" >> "$REPORT_FILE"
    awk '{print $7}' "$LOG_FILE" | sort | uniq -c | sort -nr | head -10 >> "$REPORT_FILE"

    # 4. Top 10 IP addresses
    echo "" >> "$REPORT_FILE"
    echo "Top 10 IP Addresses:" >> "$REPORT_FILE"
    awk '{print $1}' "$LOG_FILE" | sort | uniq -c | sort -nr | head -10 >> "$REPORT_FILE"

    # 5. Top 5 User Agents
    echo "" >> "$REPORT_FILE"
    echo "Top 5 User Agents:" >> "$REPORT_FILE"
    awk -F\" '{print $6}' "$LOG_FILE" | sort | uniq -c | sort -nr | head -5 >> "$REPORT_FILE"

    # 6. Status code summary
    echo "" >> "$REPORT_FILE"
    echo "HTTP Status Code Summary:" >> "$REPORT_FILE"
    awk '{print $9}' "$LOG_FILE" | sort | uniq -c | sort -nr >> "$REPORT_FILE"

    echo "" >> "$REPORT_FILE"
    echo "===== End of Report =====" >> "$REPORT_FILE"
}

# ==========================
# Main
# ==========================
if [ ! -f "$LOG_FILE" ]; then
    echo "Error: Log file not found at $LOG_FILE"
    exit 1
fi

generate_report

echo "Report generated at: $REPORT_FILE"
