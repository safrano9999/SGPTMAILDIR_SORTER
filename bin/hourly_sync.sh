#!/bin/bash
set -euo pipefail
BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CONFIG_BASE="${CONFIG_BASE:-$BASE_DIR}"
LOCK_FILE="$BASE_DIR/email_sort.lock"
LOG_FILE="$BASE_DIR/LOGS/hourly-sync.log"

MAILBOXES=()
if [ "$#" -gt 0 ]; then
  MAILBOXES=("$@")
else
  echo "Usage: $0 <mailbox-name> [mailbox-name ...]" >&2
  exit 1
fi

if [ -f "$LOCK_FILE" ]; then
  exit 0
fi

echo "[hourly_sync] $(date) – start" >> "$LOG_FILE"
(cd "$BASE_DIR" && "$BASE_DIR/bin/mail_sync.sh" "${MAILBOXES[@]}") >> "$LOG_FILE" 2>&1
(cd "$BASE_DIR" && "$BASE_DIR/bin/email_sort.sh" --no-offlineimap "${MAILBOXES[@]}") >> "$LOG_FILE" 2>&1

echo "[hourly_sync] $(date) – done" >> "$LOG_FILE"
