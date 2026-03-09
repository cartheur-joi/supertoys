#!/usr/bin/env python3
"""
Sync derivative story/planning docs from the master adaptation file.

Master source of truth:
  story/workboard.md
"""

from __future__ import annotations

import datetime as dt
import re
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
MASTER = ROOT / "story" / "workboard.md"
SCREENPLAY = ROOT / "story" / "supertoys-animated-screenplay.md"
VOICE_SCRIPT = ROOT / "planning" / "supertoys-voice-actor-script.md"
SHOTLIST_3MIN = ROOT / "planning" / "supertoys-voiceover-shotlist-3min.md"
SHOTLIST_2MIN = ROOT / "planning" / "supertoys-voiceover-shotlist-2min.md"
STORYBOARD = ROOT / "planning" / "supertoys-storyboard-panel-checklist.md"


def section_map(text: str) -> dict[str, str]:
    parts = re.split(r"^##\s+", text, flags=re.M)
    out: dict[str, str] = {}
    for part in parts[1:]:
        lines = part.splitlines()
        if not lines:
            continue
        title = lines[0].strip()
        body = "\n".join(lines[1:]).strip()
        out[title] = body
    return out


def parse_beats(beats_block: str) -> list[tuple[str, str]]:
    beats: list[tuple[str, str]] = []
    lines = beats_block.splitlines()
    i = 0
    while i < len(lines):
        m = re.match(r"^\s*(\d+)\.\s+(.*)\s*$", lines[i])
        if not m:
            i += 1
            continue
        title = m.group(2).strip()
        i += 1
        desc_lines: list[str] = []
        while i < len(lines) and not re.match(r"^\s*\d+\.\s+", lines[i]):
            if lines[i].strip():
                desc_lines.append(lines[i].strip())
            i += 1
        desc = " ".join(desc_lines).strip()
        beats.append((title, desc))
    return beats


def parse_bullets(block: str) -> list[str]:
    items = []
    for line in block.splitlines():
        m = re.match(r"^\s*-\s+(.*)$", line)
        if m:
            items.append(m.group(1).strip())
    return items


def infer_names(char_defs: list[str]) -> tuple[str, str]:
    child = "David"
    parent = "Edward"
    for item in char_defs:
        names = re.findall(r"`([^`]+)`", item)
        if not names:
            continue
        name = names[0]
        low = item.lower()
        if "synthetic child" in low:
            child = name
        if "adult male parent" in low:
            parent = name
    return child, parent


def ts() -> str:
    return dt.datetime.now().strftime("%Y-%m-%d %H:%M")


def write(path: Path, content: str) -> None:
    path.write_text(content.rstrip() + "\n", encoding="utf-8")


def build_screenplay(logline: str, beats: list[tuple[str, str]], sample_scene: str, tone: list[str]) -> str:
    lines = [
        "# A SUMMER FOR SUPERTOYS",
        "## Animated Short Screenplay Draft",
        "",
        "> Auto-generated from `story/workboard.md`.",
        f"> Last synced: {ts()}",
        "",
        f"**Logline:** {logline}",
        "",
        "**Tone:** " + "; ".join(tone),
        "",
        "---",
        "",
    ]
    for idx, (title, desc) in enumerate(beats, 1):
        lines.append(f"### SCENE {idx} - {title.upper()}")
        lines.append("")
        lines.append(desc or "TBD from master story beat.")
        lines.append("")
        lines.append("---")
        lines.append("")

    lines.append("## Sample Scene (From Master)")
    lines.append("")
    lines.append(sample_scene.strip())
    lines.append("")
    lines.append("---")
    lines.append("")
    lines.append("## End Card Suggestion")
    lines.append("**\"Nobody knows what real really means.\"**")
    return "\n".join(lines)


def build_voice_script(logline: str, beats: list[tuple[str, str]], child_name: str) -> str:
    lines = [
        "# A SUMMER FOR SUPERTOYS",
        "## Voice Actor Script (Narrator)",
        "",
        "> Auto-generated from `story/workboard.md`.",
        f"> Last synced: {ts()}",
        "",
        "**Read style:** Warm, restrained, intimate  ",
        "**Pacing target:** ~135-145 WPM  ",
        "**Breath key:** `/` short breath, `//` full breath, `(beat)` short pause",
        "",
        "---",
        "",
        f"{logline} //",
        "",
    ]
    for title, desc in beats:
        lines.append(f"{title}. /")
        lines.append(f"{desc} //")
        lines.append("")

    lines.extend(
        [
            "Still, / he stayed. //",
            "",
            f"Goodnight, {child_name}. /",
            "Goodnight, Henry. //",
            "",
            "---",
            "",
            "## Performance Pass Options",
            "- `Pass A (neutral-aching)`: Keep emotional ceiling low; rely on pauses.",
            "- `Pass B (more grief)`: Slight crack around the reveal and replacement beats.",
            "- `Pass C (hopeful close)`: Warm lift on final two lines.",
        ]
    )
    return "\n".join(lines)


def _timecode(total_seconds: int) -> str:
    mm, ss = divmod(total_seconds, 60)
    return f"{mm:02d}:{ss:02d}"


def build_shotlist(
    runtime_label: str,
    runtime_seconds: int,
    beats: list[tuple[str, str]],
    style_line: str,
) -> str:
    per = runtime_seconds // max(1, len(beats))
    extra = runtime_seconds - per * len(beats)
    sec_alloc = [per + (1 if i < extra else 0) for i in range(len(beats))]

    lines = [
        "# A SUMMER FOR SUPERTOYS",
        f"## Timed Voiceover + Shot List (Approx. {runtime_label})",
        "",
        "> Auto-generated from `story/workboard.md`.",
        f"> Last synced: {ts()}",
        "",
        f"**Target runtime:** {runtime_label}  ",
        "**Aspect:** 2.39:1 cinematic  ",
        f"**Style:** {style_line}",
        "",
        "---",
        "",
    ]
    cur = 0
    for i, ((title, desc), dur) in enumerate(zip(beats, sec_alloc), 1):
        start = _timecode(cur)
        cur += dur
        end = _timecode(cur)
        lines.append(f"### {start}-{end} ({dur}s)")
        lines.append("**VO:**  ")
        lines.append(f"{title}. {desc}")
        lines.append("")
        lines.append("**Shot list:**  ")
        lines.append(f"1. Establishing frame for {title.lower()} ({max(3, dur//3)}s)  ")
        lines.append(f"2. Character emotion closeup tied to beat ({max(3, dur//3)}s)  ")
        lines.append(f"3. Transition frame into next beat ({max(2, dur - 2*(max(3, dur//3)))}s)")
        lines.append("")
        lines.append("---")
        lines.append("")

    lines.extend(
        [
            "## Edit Notes",
            "- Keep dialogue and story updates in the master adaptation file only.",
            "- Re-run `make sync-master` after edits to propagate changes.",
        ]
    )
    return "\n".join(lines)


def update_storyboard_header(logline: str, char_changes: list[str]) -> None:
    path = STORYBOARD
    old = path.read_text(encoding="utf-8")
    marker_start = "<!-- MASTER_SYNC_START -->"
    marker_end = "<!-- MASTER_SYNC_END -->"
    block = "\n".join(
        [
            marker_start,
            "> Canon synced from `story/workboard.md`.",
            f"> Last synced: {ts()}",
            "",
            f"**Master Logline:** {logline}",
            "",
            "**Master Character Rules:**",
            *[f"- {item}" for item in char_changes],
            marker_end,
            "",
        ]
    )
    if marker_start in old and marker_end in old:
        new = re.sub(
            rf"{re.escape(marker_start)}.*?{re.escape(marker_end)}\n?",
            block,
            old,
            flags=re.S,
        )
    else:
        new = old.replace(
            "# A SUMMER FOR SUPERTOYS\n## Storyboard Panel Checklist\n\n",
            "# A SUMMER FOR SUPERTOYS\n## Storyboard Panel Checklist\n\n" + block,
        )
    write(path, new)


def main() -> None:
    master_text = MASTER.read_text(encoding="utf-8")
    sections = section_map(master_text)

    char_changes = parse_bullets(
        sections.get("Canonical Character Definitions", "")
        or sections.get("Core Character Changes", "")
    )
    tone = parse_bullets(sections.get("Tone + Style", ""))
    logline = sections.get("Short Logline", "").strip()
    beats = parse_beats(sections.get("Story Beat Outline (Animation-Friendly)", ""))
    sample_scene = sections.get("Sample Scene Rewrite (Key Emotional Pivot)", "").strip()

    if not logline or not beats:
        raise SystemExit("Master file is missing required sections: logline and/or story beats.")
    child_name, _parent_name = infer_names(char_changes)

    write(SCREENPLAY, build_screenplay(logline, beats, sample_scene, tone))
    write(VOICE_SCRIPT, build_voice_script(logline, beats, child_name))
    write(
        SHOTLIST_3MIN,
        build_shotlist("3 minutes", 180, beats, "Emotional sci-fi fairy tale"),
    )
    write(
        SHOTLIST_2MIN,
        build_shotlist("2 minutes", 120, beats, "Fast emotional cut"),
    )
    update_storyboard_header(logline, char_changes)
    print("Synced derivative docs from master adaptation.")


if __name__ == "__main__":
    main()
