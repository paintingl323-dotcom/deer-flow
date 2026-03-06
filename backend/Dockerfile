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

# Set working directory to the backend folder
WORKDIR /app/backend

# Copy backend source code directly into the current workdir
COPY backend .

# Install dependencies with cache mount
RUN --mount=type=cache,target=/root/.cache/uv \
    uv sync

# Expose ports (gateway: 8001, langgraph: 2024)
EXPOSE 8001 2024

# Default command
CMD ["uv", "run", "uvicorn", "src.gateway.app:app", "--host", "0.0.0.0", "--port", "8001"]
