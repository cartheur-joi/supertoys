#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
COMFY_DIR="$ROOT_DIR/tools/ComfyUI"
COMFY_REPO="${COMFY_REPO:-https://github.com/cartheur-joi/ComfyUI.git}"

mkdir -p "$ROOT_DIR/tools"

if [[ -d "$COMFY_DIR/.git" ]]; then
  if git -C "$COMFY_DIR" rev-parse --verify HEAD >/dev/null 2>&1; then
    echo "ComfyUI repo already exists at $COMFY_DIR"
  else
    echo "Found incomplete ComfyUI clone at $COMFY_DIR; resetting it..."
    rm -rf "$COMFY_DIR"
    echo "Cloning ComfyUI..."
    git clone "$COMFY_REPO" "$COMFY_DIR"
  fi
elif [[ ! -d "$COMFY_DIR/.git" ]]; then
  echo "Cloning ComfyUI..."
  git clone "$COMFY_REPO" "$COMFY_DIR"
fi

cd "$COMFY_DIR"

python3 -m venv .venv
source .venv/bin/activate
python3 -m pip install --upgrade pip
pip install -r requirements.txt

cat <<'EOF'

ComfyUI bootstrap complete.

Next steps:
1) Put your SDXL checkpoint in:
   tools/ComfyUI/models/checkpoints/
   Example: sd_xl_base_1.0.safetensors

2) Start ComfyUI API:
   cd tools/ComfyUI
   source .venv/bin/activate
   python main.py --listen 127.0.0.1 --port 8188

3) In another terminal, submit P17 workflow:
   make comfy-p17

EOF
