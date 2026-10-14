# Local Smart Notebook

A local-first smart notebook: upload documents, chat with them using RAG,
generate summaries, analytics, charts and presentations — all running locally.

## Structure
- `backend/`    – FastAPI app (API, core, database, ingestion, retrieval, llm, agents, tools, sandbox, artifacts, jobs, evaluation, services)
- `frontend/`   – React.js + Tailwind CSS UI
- `data/`       – uploads, qdrant vector storage, artifacts, temporary files
- `evaluation/` – experiment scripts, datasets and results
- `docs/`       – architecture, guides, API docs
- `tests/`      – unit and integration tests

## Setup
```bash
cd backend
python -m venv .venv
source .venv/Scripts/activate   # Git Bash on Windows
pip install -r requirements.txt
cp ../.env.example ../.env
uvicorn app.main:app --reload
```
