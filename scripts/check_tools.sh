#!/usr/bin/env bash
set -euo pipefail

missing=0

for bin in blender krita ffmpeg ffprobe audacity ardour zip; do
  if command -v "$bin" >/dev/null 2>&1; then
    echo "found: $bin"
  else
    echo "missing: $bin"
    missing=1
  fi
done

if [[ $missing -ne 0 ]]; then
  echo ""
  echo "One or more tools are missing."
  echo "Install baseline tools on Debian with:"
  echo "  sudo apt update && sudo apt install -y blender krita audacity ffmpeg ardour zip"
  exit 1
fi

echo ""
echo "All required baseline tools were found."

