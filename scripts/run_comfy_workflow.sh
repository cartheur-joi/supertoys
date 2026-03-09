#!/usr/bin/env bash
set -euo pipefail

WORKFLOW_JSON="${1:-tools/comfy-workflows/p17-emotional-still.json}"
API_URL="${2:-http://127.0.0.1:8188/prompt}"

if [[ ! -f "$WORKFLOW_JSON" ]]; then
  echo "Workflow file not found: $WORKFLOW_JSON"
  exit 1
fi

tmp_payload="$(mktemp /tmp/comfy-payload.XXXXXX.json)"
trap 'rm -f "$tmp_payload"' EXIT

python3 - "$WORKFLOW_JSON" > "$tmp_payload" <<'PY'
import json, sys
wf_path = sys.argv[1]
with open(wf_path, "r", encoding="utf-8") as f:
    prompt = json.load(f)
print(json.dumps({"prompt": prompt}))
PY

echo "Submitting workflow: $WORKFLOW_JSON"
echo "Endpoint: $API_URL"
curl -sS -X POST "$API_URL" -H "Content-Type: application/json" --data-binary @"$tmp_payload" | python3 -m json.tool

