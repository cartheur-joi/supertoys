#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 2 ]]; then
  echo "Usage: $0 <input_master.mov> <output_final.mp4>"
  exit 2
fi

infile="$1"
outfile="$2"

if [[ ! -f "$infile" ]]; then
  echo "Input not found: $infile"
  exit 1
fi

mkdir -p "$(dirname "$outfile")"

ffmpeg -y -i "$infile" \
  -c:v libx264 -crf 18 -preset slow -pix_fmt yuv420p \
  -c:a aac -b:a 192k \
  "$outfile"

echo "Final encode written to: $outfile"

