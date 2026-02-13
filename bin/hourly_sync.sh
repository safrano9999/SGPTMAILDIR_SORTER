#!/bin/bash
BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
LOCK_FILE="$BASE_DIR/email_sort.lock"
LOG_FILE="$BASE_DIR/LOGS/offlineimap-cron.log"

if [ -f "$LOCK_FILE" ]; then
  exit 0
fi

(cd "$BASE_DIR" && offlineimap -c "$BASE_DIR/offlineimaprc" -v -a gmail) >> "$LOG_FILE" 2>&1
