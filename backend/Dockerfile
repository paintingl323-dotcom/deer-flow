# Backend Development Dockerfile
FROM python:3.12-slim

# Install system dependencies
RUN apt-get update && apt-get install -y \
    curl \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Install uv
RUN curl -LsSf https://astral.sh/uv/install.sh | sh
ENV PATH="/root/.local/bin:$PATH"

# Set working directory
WORKDIR /app

# Copy backend source code
COPY backend ./backend

# Set working directory to backend for execution
WORKDIR /app/backend

# Install dependencies with cache mount
RUN --mount=type=cache,target=/root/.cache/uv \
    uv sync

# Expose ports (gateway: 8001, langgraph: 2024)
EXPOSE 8001 2024

# Default command - generate config.yaml from env vars then start server
CMD ["sh", "-c", "cat > /app/config.yaml << 'YAML'\nmodels:\n  - name: gemini-2.5-pro\n    display_name: Gemini 2.5 Pro\n    use: langchain_google_genai:ChatGoogleGenerativeAI\n    model: gemini-2.5-pro\n    google_api_key: GEMINI_KEY_PLACEHOLDER\n    max_tokens: 8192\n    supports_vision: true\ntool_groups:\n  - name: web\n  - name: file:read\n  - name: file:write\n  - name: bash\ntools:\n  - name: web_fetch\n    group: web\n    use: src.community.jina_ai.tools:web_fetch_tool\n    timeout: 10\nsandbox:\n  use: src.sandbox.local:LocalSandboxProvider\nYAML\nsed -i \"s|GEMINI_KEY_PLACEHOLDER|${GEMINI_API_KEY}|g\" /app/config.yaml && uv run uvicorn src.gateway.app:app --host 0.0.0.0 --port 8001"]
