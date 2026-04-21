# ── Stage 1: builder ─────────────────────────────────────────────────────────
# Install dependencies in a separate layer so they are cached between builds.
FROM python:3.12-slim AS builder

WORKDIR /install

COPY requirements.txt .
RUN pip install --no-cache-dir --prefix=/deps -r requirements.txt


# ── Stage 2: runtime ─────────────────────────────────────────────────────────
FROM python:3.12-slim

# Non-root user — security best practice for Cloud Run
RUN adduser --disabled-password --gecos "" appuser

WORKDIR /app

# Copy installed packages from builder
COPY --from=builder /deps /usr/local

# Copy application source (data/ is excluded via .dockerignore)
COPY . .

# Create writable data directory for runtime outputs
RUN mkdir -p /app/data && chown -R appuser:appuser /app

USER appuser

# Cloud Run injects PORT; default 8080 matches Cloud Run convention
ENV PORT=8080
EXPOSE 8080

# Waitress is the WSGI server — no dev server in production
CMD ["python", "serve.py"]
