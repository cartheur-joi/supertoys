#!/usr/bin/env bash
set -euo pipefail

missing=0

for bin in python3 curl ffmpeg ffprobe zip; do
  if command -v "$bin" >/dev/null 2>&1; then
    echo "found: $bin"
  else
    echo "missing: $bin"
    missing=1
  fi
done

echo ""
echo "Optional but recommended:"
for bin in blender krita audacity ardour inotifywait; do
  if command -v "$bin" >/dev/null 2>&1; then
    echo "found: $bin"
  else
    echo "missing: $bin"
  fi
done

if [[ $missing -ne 0 ]]; then
  echo ""
  echo "One or more required tools are missing."
  echo "Install baseline tools on Debian with:"
  echo "  sudo apt update && sudo apt install -y python3 curl ffmpeg zip"
  echo ""
  echo "Optional tool install:"
  echo "  sudo apt update && sudo apt install -y blender krita audacity ardour inotify-tools"
  exit 1
fi

echo ""
echo "All required baseline tools were found."
