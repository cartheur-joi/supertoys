#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
COMFY_DIR="$ROOT_DIR/tools/ComfyUI"

PORT="${COMFY_PORT:-8188}"
HOST="${COMFY_HOST:-127.0.0.1}"

# Strong CPU defaults (override via env if needed)
export OMP_NUM_THREADS="${OMP_NUM_THREADS:-16}"
export MKL_NUM_THREADS="${MKL_NUM_THREADS:-16}"

if [[ ! -d "$COMFY_DIR" ]]; then
  echo "ComfyUI not found at $COMFY_DIR"
  echo "Run: make comfy-bootstrap"
  exit 1
fi

if [[ ! -x "$COMFY_DIR/.venv/bin/python" ]]; then
  echo "ComfyUI virtual environment not found."
  echo "Run: make comfy-bootstrap"
  exit 1
fi

echo "Starting ComfyUI strong CPU profile..."
echo "Host: $HOST"
echo "Port: $PORT"
echo "OMP_NUM_THREADS=$OMP_NUM_THREADS"
echo "MKL_NUM_THREADS=$MKL_NUM_THREADS"
echo ""

cd "$COMFY_DIR"
source .venv/bin/activate
exec python main.py \
  --cpu \
  --listen "$HOST" \
  --port "$PORT" \
  --disable-auto-launch \
  --cache-lru 48 \
  --preview-method auto
