#!/usr/bin/env bash
set -euo pipefail

missing=0

required_files=(
  "production/exports/supertoys_final.mp4"
  "production/submission/metadata/logline.txt"
  "production/submission/metadata/synopsis-short.txt"
  "production/submission/metadata/synopsis-long.txt"
  "production/submission/metadata/director-statement.md"
  "production/submission/metadata/credits.md"
  "production/submission/metadata/technical-specs.md"
  "production/submission/metadata/rights-clearance-checklist.md"
  "production/submission/subtitles/supertoys_en.srt"
  "reporting/supertoys-festival-submission-tracker.csv"
)

for f in "${required_files[@]}"; do
  if [[ -f "$f" ]]; then
    echo "found: $f"
  else
    echo "missing: $f"
    missing=1
  fi
done

# Promo checks
poster_count=$(find production/submission/promo -maxdepth 1 -type f \( -iname '*poster*.jpg' -o -iname '*poster*.png' \) | wc -l | tr -d ' ')
still_count=$(find production/submission/promo -maxdepth 1 -type f \( -iname '*still*.jpg' -o -iname '*still*.png' \) | wc -l | tr -d ' ')
trailer_count=$(find production/submission/promo -maxdepth 1 -type f -iname '*.mp4' | wc -l | tr -d ' ')

if [[ "$poster_count" -ge 1 ]]; then
  echo "found: poster asset(s)"
else
  echo "missing: poster asset (expected >=1 file with 'poster' in name)"
  missing=1
fi

if [[ "$still_count" -ge 3 ]]; then
  echo "found: still asset(s) ($still_count)"
else
  echo "missing: still assets (expected >=3 files with 'still' in name)"
  missing=1
fi

if [[ "$trailer_count" -ge 1 ]]; then
  echo "found: trailer asset(s)"
else
  echo "missing: trailer asset (expected >=1 .mp4 file in production/submission/promo)"
  missing=1
fi

if [[ $missing -ne 0 ]]; then
  echo ""
  echo "Submission package is not complete."
  exit 1
fi

echo ""
echo "Submission package check passed."
