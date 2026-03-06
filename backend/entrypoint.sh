#!/bin/sh
set -e

# Generate config.yaml from environment variables
cat > /app/config.yaml << YAML
models:
  - name: gemini-2.5-pro
    display_name: Gemini 2.5 Pro
    use: langchain_google_genai:ChatGoogleGenerativeAI
    model: gemini-2.5-pro
    google_api_key: ${GEMINI_API_KEY}
    max_tokens: 8192
    supports_vision: true
tool_groups:
  - name: web
  - name: file:read
  - name: file:write
  - name: bash
tools:
  - name: web_fetch
    group: web
    use: src.community.jina_ai.tools:web_fetch_tool
    timeout: 10
sandbox:
  use: src.sandbox.local:LocalSandboxProvider
YAML

echo "Config generated, starting services..."

# Start LangGraph server in background on port 2024
LANGCHAIN_TRACING_V2=false uv run langgraph up \
  --host 0.0.0.0 \
  --port 2024 \
  --no-browser &

LANGGRAPH_PID=$!

# Wait a moment for langgraph to start
sleep 5

# Start API gateway in foreground on the main port
exec uv run uvicorn src.gateway.app:app --host 0.0.0.0 --port ${PORT:-8001}
