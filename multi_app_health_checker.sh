#!/bin/bash

URLS=(
    "https://www.google.com"
    "https://www.wikipedia.org"
    "https://api.github.com"
)
TIMEOUT=5
LOG_FILE="/var/log/app_health.log"


check_app() {
    local url=$1
    local status_code

    status_code=$(curl -s -o /dev/null -w "%{http_code}" --max-time $TIMEOUT "$url")

    if [[ "$status_code" -ge 200 && "$status_code" -lt 400 ]]; then
        echo "$(date) | $url | ✅ UP (HTTP $status_code)" | tee -a "$LOG_FILE"
    elif [[ "$status_code" -eq 000 ]]; then
        echo "$(date) | $url | ❌ DOWN (No response)" | tee -a "$LOG_FILE"
    else
        echo "$(date) | $url | ❌ DOWN (HTTP $status_code)" | tee -a "$LOG_FILE"
    fi
}

echo "========== Health Check Report: $(date) ==========" | tee -a "$LOG_FILE"
for url in "${URLS[@]}"; do
    check_app "$url"
done
echo "==================================================" | tee -a "$LOG_FILE"
echo
