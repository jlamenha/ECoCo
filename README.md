# Reproducibility Guide

This document explains how to reproduce the full-stack environment used in this repository, including API credentials, Docker setup, and how to trigger batch evaluations.

---

## Environment Variables

The application uses a single `.env` file for the backend service:

**`backend/.env.docker`**

| Variable | Description |
|---|---|
| `OPENROUTER_API_KEY` | API key used to query LLMs via the OpenRouter API |

### Where to get the API key

- **OpenRouter** — Create a free account at [openrouter.ai](https://openrouter.ai), then go to **Keys** in your dashboard to generate an API key. This key provides access to all models used in the evaluation (GPT-4o, Claude, Gemini, etc.).

Once you have the key, create the file `backend/.env.docker` with the following content:

```
OPENROUTER_API_KEY="your-key-here"
```

The frontend has no required environment variables for local development.

---

## Running with Docker

Docker is used to run the full stack (PostgreSQL database, Elixir/Phoenix backend, and React frontend) in a reproducible, containerized environment.

### Installing Docker

1. Download **Docker Desktop** from [docker.com/get-started](https://www.docker.com/get-started)
2. Install and launch Docker Desktop
3. Verify the installation by running:
   ```bash
   docker --version
   docker compose version
   ```

### Starting the stack

From the project root directory, run:

```bash
docker compose up --build
```

This will:
- Pull the `postgres:16-alpine` image and start the database
- Build and start the Phoenix backend on **http://localhost:4000**
- Build and start the React frontend on **http://localhost:3000**

On subsequent runs (no code changes), you can skip the rebuild:

```bash
docker compose up
```

To stop everything:

```bash
docker compose down
```

To stop and also delete the database volume (full reset):

```bash
docker compose down -v
```

---

## Batch Evaluation Endpoint

The backend exposes an HTTP endpoint for triggering evaluations programmatically in bulk.
It contains 300 prompts (20 schemas, 15 questions each) made for 40 episodes to 10 different models. This is how the data was collected.

> [!WARNING]
> Running the full batch evaluation sends 300 prompts × 40 episodes to 10 models and **can cost up to $300 in OpenRouter credits**. Make sure you have sufficient credits before proceeding.

**Endpoint:**

```
POST http://localhost:4000/api/evals
```

**Request body:** see [batch_request_body.json](./batch_request_body.json)

To send the batch request, paste the full JSON body into `batch_request_body.json` and run:

```bash
curl -X POST http://localhost:4000/api/evals \
  -H "Content-Type: application/json" \
  -d @batch_request_body.json
```

The evaluation results are written to CSV files inside the backend container at:

```
backend/priv/static/csv/evaluation_results.csv
backend/priv/static/csv/consistency_progression.csv
```

These CSV files are the input to the analysis scripts in `analysis/visualizations.py`.