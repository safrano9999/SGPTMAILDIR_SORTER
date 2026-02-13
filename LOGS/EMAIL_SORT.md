# Email Sorting Automation

## Overview
`email_sort.sh` processes Maildir content and classifies each message using SGPT. It moves files, logs the action, and generates a PDF report.

## Requirements
- Bash environment
- `sgpt` CLI (configured with role `json_generator`)
- `jq`, `python3`, `pandoc`
- Access to `SGPTMAILDIR_SORTER/Mail/<account>/INBOX/...`

## Configuration
Top of `email_sort.sh` contains vars:
- `MODEL`: default `gpt-4o-mini`
- `MAILBOXES`: default `("gmail")`. CLI args override.
- `CONFIG_DIR`: `SGPTMAILDIR_SORTER/rules` (per-account JSON)
- `FILTER_DB`, `EMAIL_RULES`: refer to rule files
- `SGPT_CMD`: uses `/usr/local/bin/sgpt --role json_generator`

### Per-account JSON
Place `{account}.json` in `SGPTMAILDIR_SORTER/rules/` to override model, rules, filter DB, and destination map.

## Workflow
1. Acquire lock (`email_sort.lock`).
2. For each mailbox, iterate `INBOX/sort_ai_correction/cur`, `INBOX/new`, `INBOX/cur`.
3. Extract headers + snippet via Python.
4. Prompt sgpt (role `json_generator`) with rules + filter DB.
5. Parse JSON output (`summary`, `unsubscribe`, `destination`, `reason`).
6. Map destination → Maildir path via `DEST_MAP`.
7. `mv` file, log entry (also printed to stdout).
8. After processing all messages, log final counts.
9. Run `offlineimap -o -a <mailbox>`.
10. Convert log MD → PDF → `SGPTMAILDIR_SORTER/Mail/ZEROINBOX/`.

## Destination Map Keys
- `archiv_agb` → `INBOX.Archiv.AGB`
- `archiv_bezahlt` → `INBOX.Archiv.bezahlt`
- `freitag` → `INBOX.Freitag`
- `loeschen` → `INBOX.loeschen`
- `welcome` → `INBOX.Archiv.welcome`
- `system` → `INBOX.Archiv.Systemmeldungen`
- `kommunikation` → `INBOX.Archiv.Kommunikation`
- `newsletter` → `INBOX.Archiv.newsletter`
- `uncertain` → `INBOX.sort_ai_uncertain`

## Error Handling
- If sgpt fails, raw request/response stored in `/tmp/email-sort-sgpt/`.
- Invalid JSON → stored and processing continues.
- Lock prevents concurrent runs; offlineimap sync uses same mailbox list.

## Output
- Main log: `SGPTMAILDIR_SORTER/LOGS/email-sort-<timestamp>.md`
- PDF copy: `SGPTMAILDIR_SORTER/Mail/ZEROINBOX/email-sort-<timestamp>.pdf`
