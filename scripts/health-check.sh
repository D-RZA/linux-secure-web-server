#!/usr/bin/env bash

# Linux Capstone - Server Health Check
# Ubuntu Azure VM

DISK_THRESHOLD=80
MEMORY_THRESHOLD=90
STATUS=0

pass() {
    printf '[PASS] %s\n' "$1"
}

warn() {
    printf '[WARN] %s\n' "$1"
}

fail() {
    printf '[FAIL] %s\n' "$1"
    STATUS=1
}

printf '%s\n' "=================================="
printf '%s\n' " LINUX SERVER HEALTH CHECK"
printf '%s\n' "=================================="
printf 'Hostname: %s\n' "$(hostname)"
printf 'Date: %s\n\n' "$(date)"

# 1. Nginx service check
if systemctl is-active --quiet nginx; then
    pass "Nginx service is running"
else
    fail "Nginx service is not running"
fi

# 2. HTTP availability check
HTTP_CODE=$(curl -sS -o /dev/null -w '%{http_code}' --max-time 5 http://127.0.0.1 2>/dev/null)
CURL_STATUS=$?

if [ "$CURL_STATUS" -eq 0 ] && [ "$HTTP_CODE" = "200" ]; then
    pass "Website responds with HTTP 200"
else
    fail "Website check failed (curl status: $CURL_STATUS, HTTP: ${HTTP_CODE:-none})"
fi

# 3. Root filesystem usage
DISK_USAGE=$(df -P / | awk 'NR==2 {gsub("%", "", $5); print $5}')

if [[ "$DISK_USAGE" =~ ^[0-9]+$ ]]; then
    if [ "$DISK_USAGE" -ge "$DISK_THRESHOLD" ]; then
        warn "Disk usage is ${DISK_USAGE}% (threshold: ${DISK_THRESHOLD}%)"
    else
        pass "Disk usage is ${DISK_USAGE}%"
    fi
else
    fail "Could not determine disk usage"
fi

# 4. Memory usage (used = total - available)
read -r MEMORY_TOTAL MEMORY_AVAILABLE < <(
    free -m | awk '/^Mem:/ {print $2, $7}'
)

if [[ "$MEMORY_TOTAL" =~ ^[0-9]+$ ]] &&
   [[ "$MEMORY_AVAILABLE" =~ ^[0-9]+$ ]] &&
   [ "$MEMORY_TOTAL" -gt 0 ]; then
    MEMORY_USAGE=$(( (MEMORY_TOTAL - MEMORY_AVAILABLE) * 100 / MEMORY_TOTAL ))

    if [ "$MEMORY_USAGE" -ge "$MEMORY_THRESHOLD" ]; then
        warn "Memory usage is ${MEMORY_USAGE}% (threshold: ${MEMORY_THRESHOLD}%)"
    else
        pass "Memory usage is ${MEMORY_USAGE}%"
    fi
else
    fail "Could not determine memory usage"
fi

# 5. Uptime
UPTIME=$(uptime -p 2>/dev/null)

if [ -n "$UPTIME" ]; then
    pass "System uptime: $UPTIME"
else
    warn "Could not determine system uptime"
fi

printf '\n%s\n' "=================================="
if [ "$STATUS" -eq 0 ]; then
    printf '%s\n' " RESULT: HEALTH CHECK PASSED"
else
    printf '%s\n' " RESULT: HEALTH CHECK FAILED"
fi
printf '%s\n' "=================================="

exit "$STATUS"
