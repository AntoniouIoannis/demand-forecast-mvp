#!/usr/bin/env python3
"""
Production entrypoint — uses Waitress WSGI server.

Local usage:
    python serve.py

Cloud Run injects the PORT environment variable automatically.
Waitress is cross-platform (Windows + Linux), so the same file
works both locally and inside the Docker container.
"""
from __future__ import annotations

import os

from waitress import serve

from app import app

HOST = "0.0.0.0"
PORT = int(os.environ.get("PORT", 8080))
THREADS = int(os.environ.get("WAITRESS_THREADS", 4))

if __name__ == "__main__":
    print(f"Starting Waitress on http://{HOST}:{PORT}  (threads={THREADS})")
    serve(app, host=HOST, port=PORT, threads=THREADS)
