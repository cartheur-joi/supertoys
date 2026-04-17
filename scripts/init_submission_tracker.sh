#!/usr/bin/env bash
set -euo pipefail

OUT="${1:-reporting/supertoys-festival-submission-tracker.csv}"

mkdir -p "$(dirname "$OUT")"

if [[ -f "$OUT" ]]; then
  echo "Tracker already exists: $OUT"
  echo "No changes made."
  exit 0
fi

cat > "$OUT" <<'CSV'
festival,platform,category,deadline_date,entry_fee,status,submission_date,confirmation_id,notification_date,premiere_requirement,notes
Clermont-Ferrand International Short Film Festival,Shortfilmdepot,Animation,,,,,,,,
Shortfilmdepot Profile Listing,Shortfilmdepot,Animation,,,,,,,,
FilmFreeway Target #1,FilmFreeway,Animation,,,,,,,,
FilmFreeway Target #2,FilmFreeway,Sci-Fi,,,,,,,,
FilmFreeway Target #3,FilmFreeway,International Shorts,,,,,,,,
Festhome Target #1,Festhome,Animation,,,,,,,,
Festhome Target #2,Festhome,Sci-Fi,,,,,,,,
Festhome Target #3,Festhome,International Shorts,,,,,,,,
Target #9,TBD,TBD,,,,,,,,
Target #10,TBD,TBD,,,,,,,,
CSV

echo "Created festival submission tracker: $OUT"
