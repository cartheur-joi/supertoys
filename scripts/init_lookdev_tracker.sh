#!/usr/bin/env bash
set -euo pipefail

OUT="${1:-production/refs/lookdev-tracker.csv}"

mkdir -p "$(dirname "$OUT")"

if [[ -f "$OUT" ]]; then
  echo "Tracker already exists: $OUT"
  echo "No changes made."
  exit 0
fi

cat > "$OUT" <<'CSV'
panel,priority,emotion,tool,model,prompt_version,seed,image_candidate,selected,notes
P17,high,tension,,,,,,no,
P20,high,grief,,,,,,no,
P25,high,separation,,,,,,no,
P27,high,silent_pain,,,,,,no,
P28,high,protection,,,,,,no,
P30,high,existential_fear,,,,,,no,
P31,high,reassurance,,,,,,no,
P32,high,fragile_peace,,,,,,no,
P01,medium,unease,,,,,,no,
P07,medium,support,,,,,,no,
P19,medium,shock,,,,,,no,
P23,medium,turning_point,,,,,,no,
CSV

echo "Created lookdev tracker: $OUT"

