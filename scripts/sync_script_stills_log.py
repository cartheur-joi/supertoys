#!/usr/bin/env python3
"""Generate reporting/supertoys-script-stills-log.md from tracker + EDL."""

from __future__ import annotations

import csv
from datetime import datetime
from pathlib import Path


def load_edl(path: Path) -> dict[str, dict[str, str]]:
    by_panel: dict[str, dict[str, str]] = {}
    with path.open("r", encoding="utf-8", newline="") as f:
        for row in csv.DictReader(f):
            panel = (row.get("panel") or "").strip()
            if panel:
                by_panel[panel] = row
    return by_panel


def load_tracker(path: Path) -> list[dict[str, str]]:
    with path.open("r", encoding="utf-8", newline="") as f:
        return list(csv.DictReader(f))


def make_notes(row: dict[str, str], panel: str) -> str:
    parts: list[str] = []
    if row.get("tool"):
        parts.append(f"tool `{row['tool']}`")
    if row.get("model"):
        parts.append(f"model `{row['model']}`")
    if row.get("prompt_version"):
        parts.append(f"prompt `{row['prompt_version']}`")
    if row.get("seed"):
        parts.append(f"seed `{row['seed']}`")
    if row.get("image_candidate"):
        parts.append(f"candidate `{row['image_candidate']}`")
    if not parts and (row.get("selected") or "").strip().lower() == "yes":
        parts.append(f"selected still `production/selects/{panel}/{panel}_select.png`")
    if row.get("notes"):
        parts.append(row["notes"].strip())
    return "; ".join([p for p in parts if p])


def render(rows: list[dict[str, str]], edl: dict[str, dict[str, str]]) -> str:
    now = datetime.now().strftime("%Y-%m-%d %H:%M")
    out: list[str] = []
    out.append("# Supertoys Script + Stills Log")
    out.append("")
    out.append("Living output file to track script beats and selected stills as we generate panels.")
    out.append("")
    out.append(f"> Last synced: {now}")
    out.append("")
    out.append("## Script Sources")
    out.append("")
    out.append("- Narrative script: `planning/supertoys-voice-actor-script.md`")
    out.append("- Story screenplay: `reporting/supertoys-animated-screenplay.md`")
    out.append("- Timing + shot intent: `animatic/supertoys-edit-decision-list.csv`")
    out.append("")
    out.append("## Panel Log (Rolling)")
    out.append("")
    out.append("| Panel | Time | Script/Shot Beat | Selected Still | Status | Notes |")
    out.append("|---|---|---|---|---|---|")

    for row in rows:
        panel = (row.get("panel") or "").strip()
        if not panel:
            continue
        edl_row = edl.get(panel, {})
        time_in = (edl_row.get("time_in") or "").strip()
        time_out = (edl_row.get("time_out") or "").strip()
        time_range = f"{time_in}-{time_out}" if time_in and time_out else "TBD"
        beat = (edl_row.get("video_note") or row.get("emotion") or "TBD").strip()
        selected = (row.get("selected") or "").strip().lower() == "yes"
        still = f"`production/selects/{panel}/{panel}_select.png`" if selected else "`TBD`"
        status = "selected" if selected else "pending"
        notes = make_notes(row, panel) or " "
        out.append(f"| {panel} | {time_range} | {beat} | {still} | {status} | {notes} |")

    out.append("")
    out.append("## Update Rule")
    out.append("")
    out.append("1. Select stills into `production/selects/<PANEL>/<PANEL>_select.png`")
    out.append("2. Update `production/refs/lookdev-tracker.csv` metadata")
    out.append("3. Run `make script-stills-sync` to refresh this file")
    out.append("")
    return "\n".join(out)


def main() -> int:
    root = Path(__file__).resolve().parents[1]
    tracker_path = root / "production/refs/lookdev-tracker.csv"
    edl_path = root / "animatic/supertoys-edit-decision-list.csv"
    output_path = root / "reporting/supertoys-script-stills-log.md"

    rows = load_tracker(tracker_path)
    edl = load_edl(edl_path)
    output_path.write_text(render(rows, edl), encoding="utf-8")
    print(f"Wrote {output_path}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

