#!/usr/bin/env bash
set -euo pipefail

MASTER_FILE="${1:-story/animated-story-adaptation.md}"

if [[ ! -f "$MASTER_FILE" ]]; then
  echo "Master file not found: $MASTER_FILE"
  exit 1
fi

if ! command -v inotifywait >/dev/null 2>&1; then
  echo "Missing dependency: inotifywait"
  echo "Install with: sudo apt install -y inotify-tools"
  exit 1
fi

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

DERIVED_FILES=(
  "story/supertoys-animated-screenplay.md"
  "planning/supertoys-voice-actor-script.md"
  "planning/supertoys-voiceover-shotlist-3min.md"
  "planning/supertoys-voiceover-shotlist-2min.md"
  "planning/supertoys-storyboard-panel-checklist.md"
)

STATE_DIR="$(mktemp -d /tmp/supertoys-master-watch.XXXXXX)"
trap 'rm -rf "$STATE_DIR"' EXIT
PREV_MASTER="$STATE_DIR/prev_master.md"
PREV_DERIVED="$STATE_DIR/derived_prev"
mkdir -p "$PREV_DERIVED"

cp "$MASTER_FILE" "$PREV_MASTER"
for f in "${DERIVED_FILES[@]}"; do
  if [[ -f "$f" ]]; then
    mkdir -p "$PREV_DERIVED/$(dirname "$f")"
    cp "$f" "$PREV_DERIVED/$f"
  fi
done

echo "Watching $MASTER_FILE"
echo "On each save: show diff from previous save, run make sync-master, show derived diffs."
echo ""

while true; do
  inotifywait -qq -e close_write,moved_to "$(dirname "$MASTER_FILE")"
  # Ignore events from other files in the same folder.
  if ! cmp -s "$MASTER_FILE" "$PREV_MASTER"; then
    echo "=== $(date '+%Y-%m-%d %H:%M:%S') save detected ==="
    echo "-- Master file diff (previous save -> current) --"
    diff -u "$PREV_MASTER" "$MASTER_FILE" || true
    echo ""

    echo "-- Running make sync-master --"
    if make sync-master; then
      echo "sync-master: OK"
    else
      echo "sync-master: FAILED"
      echo ""
      cp "$MASTER_FILE" "$PREV_MASTER"
      continue
    fi
    echo ""

    echo "-- Derived file diffs --"
    changed=0
    for f in "${DERIVED_FILES[@]}"; do
      prev="$PREV_DERIVED/$f"
      if [[ -f "$prev" ]] && [[ -f "$f" ]]; then
        if ! cmp -s "$prev" "$f"; then
          echo "### $f"
          diff -u "$prev" "$f" || true
          echo ""
          changed=1
        fi
      elif [[ -f "$f" ]]; then
        echo "### $f (new)"
        cat "$f"
        echo ""
        changed=1
      fi
    done
    if [[ "$changed" -eq 0 ]]; then
      echo "No derived file changes."
      echo ""
    fi

    cp "$MASTER_FILE" "$PREV_MASTER"
    rm -rf "$PREV_DERIVED"
    mkdir -p "$PREV_DERIVED"
    for f in "${DERIVED_FILES[@]}"; do
      if [[ -f "$f" ]]; then
        mkdir -p "$PREV_DERIVED/$(dirname "$f")"
        cp "$f" "$PREV_DERIVED/$f"
      fi
    done
  fi
done

