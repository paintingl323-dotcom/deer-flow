# Backend Dockerfile for Render deployment
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

# Copy entrypoint script
COPY backend/entrypoint.sh ./entrypoint.sh
RUN chmod +x ./entrypoint.sh

# Set working directory to backend
WORKDIR /app/backend

# Install dependencies
RUN --mount=type=cache,target=/root/.cache/uv \
    uv sync

# Expose port
EXPOSE 10000

# Use entrypoint script
CMD ["/app/entrypoint.sh"]
