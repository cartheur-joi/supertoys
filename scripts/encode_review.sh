#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 2 ]]; then
  echo "Usage: $0 <input_master.mov> <output_review.mp4>"
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
  -c:v libx264 -crf 24 -preset veryfast -pix_fmt yuv420p \
  -c:a aac -b:a 128k \
  "$outfile"

echo "Review encode written to: $outfile"

