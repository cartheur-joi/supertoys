#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 <mix.wav>"
  exit 2
fi

infile="$1"

if [[ ! -f "$infile" ]]; then
  echo "Input not found: $infile"
  exit 1
fi

echo "Running loudness analysis for: $infile"
echo ""

# Prints integrated loudness summary and true peak in ffmpeg output.
ffmpeg -hide_banner -i "$infile" -af loudnorm=I=-16:LRA=11:TP=-1:print_format=summary -f null -

