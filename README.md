# ZeroInbox 2026 – SGPT Maildir Sorter ⚡📬

Dieses Projekt automatisiert deinen ZeroInbox‑Workflow: **Mails werden lokal sortiert, geloggt und als PDF geliefert** – du musst die Inbox nicht mehr manuell durchgehen.

> ✅ Fokus: 2026‑ready, lokal, schnell, transparent.

---

## ✨ Was du bekommst
- Automatisches **Sortieren** deiner Maildir‑Inbox
- **Logs + PDF‑Report** (von OpenClaw ausgeliefert)
- **Correction‑Loop** für False Positives
- Struktur für **künftiges ML‑Tuning**

---

## 🧠 Wichtig: GPT/SGPT konfigurieren
Du brauchst `sgpt` + API Key. Stelle sicher:
- `sgpt` ist installiert
- API Key ist gesetzt (z. B. via `.bashrc_sgpt`)

---

## ✅ Setup‑Reihenfolge (wichtig!)
**Exakt diese Reihenfolge einhalten:**

1) **offlineimaprc konfigurieren**
   - Datei: `offlineimaprc`
   - Beispiel: `offlineimaprc_example`
   - Trage deine Gmail‑Accounts ein

2) **Sync laufen lassen**
   ```bash
   bin/mail_sync.sh gmail
   ```

3) **Mirror‑JSON erstellen**
   ```bash
   bin/mirror.sh Mail/gmail
   ```

4) **Ordner‑Flags setzen** (im `mirror_dir_*.json`)
   Pro Ordner drei Optionen:
   - `is_source` → wird gescannt
   - `is_destination` → darf Ziel sein
   - `is_fallback` → fallback (unsicher)

5) **Sortieren**
   ```bash
   bin/email_sort.sh gmail
   ```

---

## 🔁 Correction‑Loop (False Positives)
Wenn eine Mail falsch einsortiert wurde:
1) **In `sort_ai_correction` legen**
2) Beim nächsten Lauf wird **das alte Ziel ausgeschlossen**
3) Die Korrektur landet in `corrections.jsonl`

> Nach einiger Zeit kannst du eine **KI über die corrections.jsonl jagen**, um Keywords & Regeln zu optimieren.

---

## ⏱ Cronjob‑Hinweis
Wenn du einen Cronjob nutzt (z. B. `hourly_sync.sh`):
- Lockfile verhindert Doppel‑Runs
- Logs + PDF werden automatisch erzeugt
- OpenClaw liefert das PDF, du musst keine Mail‑UI öffnen

---

## 📂 Projektstruktur (Kurz)
```
SGPTMAILDIR_SORTER/
├─ bin/
│  ├─ email_sort.sh
│  ├─ mail_sync.sh
│  ├─ mirror.sh
├─ Mail/                # Maildir Root
├─ LOGS/                # Logs + PDF reports
├─ rules/
│  ├─ rules_generic.json
│  ├─ rules_custom.json (ignored)
├─ mirror_dir_gmail.json_example
├─ offlineimaprc_example
```

---

## 🧩 ML‑Optimierung (später)
Workflow:
1) Corrections sammeln (`corrections.jsonl`)
2) KI fragt: „Welche Keywords sorgen für False Positives?“
3) JSON‑Rules anpassen

---

## ✅ Fazit
- **ZeroInbox ohne UI‑Stress**
- **PDF statt Posteingang**
- **Regeln + Korrekturen = stetige Verbesserung**

Wenn du willst, baue ich dir das ML‑Optimierungs‑Tool als nächsten Schritt. 🚀
