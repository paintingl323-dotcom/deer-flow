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

echo "Config generated at /app/config.yaml"

# Set the DEER_FLOW_CONFIG_PATH so langgraph server can find the config
export DEER_FLOW_CONFIG_PATH=/app/config.yaml

# Also disable LangSmith tracing to avoid auth errors
export LANGCHAIN_TRACING_V2=false

echo "Starting LangGraph server on port ${PORT:-2024}..."

# Start LangGraph Dev Server - this handles /runs/stream
exec uv run langgraph dev \
  --host 0.0.0.0 \
  --port ${PORT:-2024} \
  --no-browser
