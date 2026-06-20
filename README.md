<div align="center">

# 🧠 Mindkeeper

**An AI-powered second brain Telegram bot — built with n8n, Groq, and PostgreSQL**

![n8n](https://img.shields.io/badge/n8n-workflow-orange?style=flat-square&logo=n8n)
![Groq](https://img.shields.io/badge/Groq-LLaMA%203.3-blue?style=flat-square)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-16-blue?style=flat-square&logo=postgresql)
![Docker](https://img.shields.io/badge/Docker-compose-2496ED?style=flat-square&logo=docker)
![Telegram](https://img.shields.io/badge/Telegram-Bot-26A5E4?style=flat-square&logo=telegram)
![License](https://img.shields.io/badge/license-MIT-green?style=flat-square)

*Send a thought. The AI sorts it. Retrieve it anytime — in plain language.*

</div>

---

## What is this?

Mindkeeper is a personal second brain that lives inside your Telegram. You send it anything — a task, an idea, a journal entry — and an AI agent automatically classifies it, cleans it up, and saves it to your own private database. When you want your notes back, you just ask in plain language: *"show me my ideas"* or *"what tasks do I have?"* — no commands, no syntax, just conversation.

Everything runs locally on your machine via Docker. No cloud subscription, no third-party storage, no monthly fees. Your data stays yours.

---

## Demo

```
You:  "I want to build a fitness tracking app someday"
Bot:  ✅ Saved as idea: build a fitness tracking app

You:  "remind me to buy groceries tomorrow"
Bot:  ✅ Saved as task: buy groceries tomorrow

You:  "today was a really tough day, i felt overwhelmed with everything"
Bot:  ✅ Saved as journal: Today was a really tough day, I felt overwhelmed with everything

You:  "show me all my notes"
Bot:  📓 Your notes:

      💡 [IDEA] build a fitness tracking app
      ✅ [TASK] buy groceries tomorrow
      📔 [JOURNAL] Today was a really tough day, I felt overwhelmed with everything
```

---

## Architecture

```
Telegram Message
      │
      ▼
 AI Agent (Groq / LLaMA 3.3)
 Classifies intent: save or retrieve?
      │
      ├── save ──────► Postgres (INSERT) ──► Telegram confirmation
      │
      └── retrieve ──► Postgres (SELECT) ──► Code (format) ──► Telegram reply
```

Two workflows, one shared database:

- **Workflow 1 (Capture)** — triggered by every Telegram message. AI reads the message, decides if it's a note to save or a retrieval request, and acts accordingly.
- **Workflow 2 (Weekly Digest)** — runs every Sunday automatically. Reads all entries from the past week, sends you a clean summary via Telegram. *(coming soon)*

---

## Tech Stack

| Layer | Tool | Why |
|---|---|---|
| Automation | [n8n](https://n8n.io) | Visual workflow builder, self-hosted |
| AI Brain | [Groq](https://groq.com) + LLaMA 3.3 70B | Fast, free inference |
| Database | PostgreSQL 16 | Reliable, local, no limits |
| Interface | Telegram Bot | Available on all devices |
| Infrastructure | Docker + Docker Compose | One command setup |
| Tunnel | Cloudflare Tunnel | Free HTTPS for local webhooks |

---

## Prerequisites

- Docker and Docker Compose installed
- A Telegram account
- A free [Groq API key](https://console.groq.com)
- A free [Cloudflare](https://cloudflare.com) account (for tunnel)

---

## Setup

### 1. Clone the repo

```bash
git clone https://github.com/yourusername/mindkeeper.git
cd mindkeeper
```

### 2. Create your Telegram bot

Open Telegram, search for `@BotFather`, send `/newbot`, follow the steps, and copy the token it gives you.

### 3. Set up environment variables

```bash
cp .env.example .env
```

Edit `.env` and fill in your values:

```env
WEBHOOK_URL=https://your-cloudflare-tunnel-url.trycloudflare.com/
TELEGRAM_BOT_TOKEN=your_telegram_bot_token
GROQ_API_KEY=your_groq_api_key
```

### 4. Start the Cloudflare tunnel

```bash
./cloudflared tunnel --url http://localhost:5678
```

Copy the generated URL (e.g. `https://some-words.trycloudflare.com`) and paste it as `WEBHOOK_URL` in your `.env`. Keep this terminal open.

### 5. Start everything

```bash
docker compose up -d
```

### 6. Open n8n and import the workflow

Go to `http://localhost:5678`, create your account, then go to **Workflows → Import** and upload `workflow.json`.

### 7. Configure credentials inside n8n

- Add your **Telegram Bot Token** under Telegram credentials
- Add your **Groq API Key** under Groq credentials
- Set your **Postgres** credentials: host = `mindkeeper-db`, port = `5432`, database = `mindkeeper`, user = `postgres`, password = `mindkeeper123`

### 8. Activate the workflow

Hit **Publish** in n8n. Send your bot a message on Telegram. That's it.

---

## Project Structure

```
mindkeeper/
├── docker-compose.yml      # Spins up n8n + PostgreSQL
├── init.sql                # Creates the entries table on first boot
├── workflow.json           # n8n workflow (import this)
├── .env.example            # Environment variable template
└── README.md
```

---

## Database Schema

```sql
CREATE TABLE entries (
  id          SERIAL PRIMARY KEY,
  created_at  TIMESTAMP DEFAULT NOW(),
  category    TEXT,   -- 'task', 'idea', or 'journal'
  content     TEXT    -- cleaned, AI-processed note
);
```

---

## How the AI classification works

Every message you send goes through an LLaMA 3.3 70B model running on Groq. The model is given a system prompt that teaches it two things:

1. **Save intent** — if you're capturing a thought, it extracts a clean version and assigns a category (`task`, `idea`, or `journal`)
2. **Retrieve intent** — if you're asking to see your notes, it decides the filter (`all`, `task`, `idea`, `journal`) and triggers a database query

The model responds with a structured JSON object that n8n then routes into the correct workflow branch. No hardcoded keywords, no `/commands` — just natural language understood by a real AI.

---

## Roadmap

- [x] Capture notes via Telegram
- [x] AI classification (task / idea / journal)
- [x] Save to PostgreSQL
- [x] Retrieve notes in plain language with category filter
- [ ] Weekly digest sent every Sunday
- [ ] Voice note support (Whisper transcription via Groq)
- [ ] Delete or edit a saved note
- [ ] Search notes by keyword

---

## License

MIT — do whatever you want with it.

---

<div align="center">

Built with n8n · Groq · PostgreSQL · Docker · Telegram

*A real project, built from scratch, to learn AI agent automation.*

</div>
