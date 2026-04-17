#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
COMFY_DIR="$ROOT_DIR/tools/ComfyUI"
COMFY_REPO="${COMFY_REPO:-https://github.com/cartheur-joi/ComfyUI.git}"
BACKUP_DIR=""

cleanup_backup() {
  if [[ -n "$BACKUP_DIR" && -d "$BACKUP_DIR" ]]; then
    # If a preserved models dir still exists in backup (e.g. clone/install failed),
    # restore it so in-progress model transfers are never stranded in /tmp.
    if [[ -d "$BACKUP_DIR/models" ]]; then
      mkdir -p "$COMFY_DIR/models"
      cp -a "$BACKUP_DIR/models/." "$COMFY_DIR/models/"
    fi
    rm -rf "$BACKUP_DIR"
  fi
}

trap cleanup_backup EXIT

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
  if [[ -d "$COMFY_DIR" && -n "$(ls -A "$COMFY_DIR")" ]]; then
    BACKUP_DIR="$(mktemp -d /tmp/comfyui-preserve.XXXXXX)"
    if [[ -d "$COMFY_DIR/models" ]]; then
      echo "Preserving existing models directory..."
      mv "$COMFY_DIR/models" "$BACKUP_DIR/models"
    fi
    rm -rf "$COMFY_DIR"
    echo "Cloning ComfyUI..."
    git clone "$COMFY_REPO" "$COMFY_DIR"
    if [[ -d "$BACKUP_DIR/models" ]]; then
      rm -rf "$COMFY_DIR/models"
      mv "$BACKUP_DIR/models" "$COMFY_DIR/models"
    fi
    rm -rf "$BACKUP_DIR"
    BACKUP_DIR=""
  else
    echo "Cloning ComfyUI..."
    git clone "$COMFY_REPO" "$COMFY_DIR"
  fi
fi

cd "$COMFY_DIR"

# Prefer Python 3.11 for faster/more reliable torch wheel resolution.
if [[ -n "${COMFY_PYTHON:-}" ]]; then
  PYTHON_BIN="$COMFY_PYTHON"
elif command -v python3.11 >/dev/null 2>&1; then
  PYTHON_BIN="python3.11"
else
  PYTHON_BIN="python3"
fi

"$PYTHON_BIN" -m venv .venv
source .venv/bin/activate
python -m pip install --upgrade pip

# Install torch explicitly first so non-NVIDIA hosts avoid heavy CUDA downloads.
TORCH_MODE="${COMFY_TORCH_MODE:-auto}"
if [[ "$TORCH_MODE" == "auto" ]]; then
  if command -v nvidia-smi >/dev/null 2>&1 && [[ "${COMFY_FORCE_CPU:-0}" != "1" ]]; then
    TORCH_MODE="default"
  else
    TORCH_MODE="cpu"
  fi
fi

if [[ "$TORCH_MODE" == "cpu" ]]; then
  echo "Installing CPU-only torch wheels..."
  pip install --index-url https://download.pytorch.org/whl/cpu torch torchvision torchaudio
else
  echo "Installing default torch wheels..."
  pip install torch torchvision torchaudio
fi

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
