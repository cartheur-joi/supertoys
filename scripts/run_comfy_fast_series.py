#!/usr/bin/env python3
"""Run unattended fast ComfyUI panel series for pending lookdev shots."""

from __future__ import annotations

import argparse
import copy
import csv
import json
import shutil
import subprocess
import sys
import time
import urllib.error
import urllib.request
from pathlib import Path


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--api-url",
        default="http://127.0.0.1:8188/prompt",
        help="ComfyUI prompt API endpoint",
    )
    parser.add_argument(
        "--template",
        default="tools/comfy-workflows/p17-emotional-still-fast.json",
        help="Workflow template JSON path",
    )
    parser.add_argument(
        "--panels",
        default="",
        help="Comma-separated panels (e.g. P25,P27). Default: pending panels from tracker.",
    )
    parser.add_argument(
        "--notify",
        action="store_true",
        help="Play/start terminal notification tone at key milestones.",
    )
    parser.add_argument(
        "--poll-seconds",
        type=float,
        default=3.0,
        help="Polling interval while waiting for each render to finish.",
    )
    parser.add_argument(
        "--force",
        action="store_true",
        help="Do not skip panels with existing fast render candidates.",
    )
    return parser.parse_args()


def load_csv_rows(path: Path) -> list[dict[str, str]]:
    with path.open("r", encoding="utf-8", newline="") as f:
        return list(csv.DictReader(f))


def pending_panels_from_tracker(rows: list[dict[str, str]]) -> list[str]:
    out: list[str] = []
    for row in rows:
        panel = (row.get("panel") or "").strip()
        selected = (row.get("selected") or "").strip().lower()
        if panel and selected != "yes":
            out.append(panel)
    return out


def panel_seed(panel: str) -> int:
    # Stable deterministic seed per panel.
    num = int(panel[1:])
    return 42000000 + (num * 101)


def scene_context_for_panel(panel: str) -> str:
    num = int(panel[1:])
    if 1 <= num <= 4:
        return "artificial summer garden exterior, open air, botanical atmosphere"
    if 5 <= num <= 12:
        return "nursery desk area interior, intimate close framing, letter-writing props"
    if 13 <= num <= 16:
        return "corporate event hall interior, stage lighting, public spectacle tone"
    if 17 <= num <= 24:
        return "domestic confrontation interior, emotional pressure, key props in frame"
    if num == 25:
        return "exterior window vantage, subjects separated by glass, indoors visible beyond"
    if 26 <= num <= 29:
        return "transitional dusk space, threshold between inside and outside, emotional distance"
    if 30 <= num <= 32:
        return "night nursery mood, low-key lighting, calm-but-fragile atmosphere"
    return "cinematic story frame with environment continuity"


def p17_style_anchor() -> str:
    return (
        "match visual language of approved P17 still: intimate eye-level tension, "
        "warm-but-uneasy amber practical lighting, shallow-to-medium depth of field, "
        "grounded retro-futurist realism, restrained palette, painterly photoreal texture, "
        "subtle film grain"
    )


def build_prompt(panel: str, video_note: str, emotion: str) -> str:
    beat = video_note.strip().lower() if video_note.strip() else "cinematic still scene"
    emo = emotion.replace("_", " ").strip().lower() if emotion.strip() else "emotional tension"
    scene = scene_context_for_panel(panel)
    style = p17_style_anchor()
    return (
        f"{beat}, emotional beat {emo}, {scene}, {style}, "
        "warm-but-uneasy cinematic lighting, emotional sci-fi fairy tale, "
        "painterly photoreal style, 2.39:1"
    )


def submit(api_url: str, payload: dict) -> dict:
    data = json.dumps(payload).encode("utf-8")
    req = urllib.request.Request(
        api_url,
        data=data,
        headers={"Content-Type": "application/json"},
        method="POST",
    )
    with urllib.request.urlopen(req, timeout=120) as resp:
        return json.loads(resp.read().decode("utf-8"))


def fetch_json(url: str) -> dict:
    req = urllib.request.Request(url, method="GET")
    with urllib.request.urlopen(req, timeout=120) as resp:
        return json.loads(resp.read().decode("utf-8"))


def history_url_for(api_url: str, prompt_id: str) -> str:
    base = api_url
    if base.endswith("/prompt"):
        base = base[: -len("/prompt")]
    return f"{base}/history/{prompt_id}"


def first_output_image(history_payload: dict, prompt_id: str) -> tuple[str, str] | None:
    block = history_payload.get(prompt_id)
    if not isinstance(block, dict):
        return None
    outputs = block.get("outputs", {})
    if not isinstance(outputs, dict):
        return None
    for node_output in outputs.values():
        if not isinstance(node_output, dict):
            continue
        images = node_output.get("images")
        if not isinstance(images, list):
            continue
        for image in images:
            if not isinstance(image, dict):
                continue
            filename = image.get("filename")
            subfolder = image.get("subfolder", "")
            if filename:
                return str(subfolder), str(filename)
    return None


def notify_tone(enabled: bool, label: str) -> None:
    if not enabled:
        return
    print(f"\n=== {label} ===", flush=True)
    # Always emit terminal bell.
    print("\a", end="", flush=True)
    # Best-effort audible tone if available.
    if shutil.which("paplay"):
        sound = "/usr/share/sounds/freedesktop/stereo/complete.oga"
        subprocess.run(["paplay", sound], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, check=False)
    elif shutil.which("play"):
        subprocess.run(
            ["play", "-nq", "-t", "alsa", "synth", "0.12", "sine", "880"],
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
            check=False,
        )


def copy_candidate_image(root: Path, panel: str, subfolder: str, filename: str) -> tuple[str, str]:
    output_root = root / "tools/ComfyUI/output"
    src = output_root / subfolder / filename if subfolder else output_root / filename
    if not src.exists():
        raise FileNotFoundError(f"Rendered file not found: {src}")

    dst_dir = root / "production" / "selects" / panel
    dst_dir.mkdir(parents=True, exist_ok=True)

    # Keep every rerender as a unique candidate file (never overwrite).
    stamp = time.strftime("%Y%m%d_%H%M%S")
    dst_copied = dst_dir / f"{panel}_candidate_{stamp}.png"
    if dst_copied.exists():
        # Extremely unlikely (same-second collision), add monotonic suffix.
        dst_copied = dst_dir / f"{panel}_candidate_{stamp}_{time.time_ns() % 100000}.png"
    shutil.copy2(src, dst_copied)

    # Optional "latest" convenience file, with archival safety on overwrite.
    latest_name = f"{panel}_candidate_latest.png"
    dst_latest = dst_dir / latest_name
    if dst_latest.exists():
        archive_dir = dst_dir / "archive"
        archive_dir.mkdir(parents=True, exist_ok=True)
        archived = archive_dir / f"{latest_name}.{stamp}"
        if archived.exists():
            archived = archive_dir / f"{latest_name}.{stamp}.{time.time_ns() % 100000}"
        shutil.move(str(dst_latest), str(archived))
    shutil.copy2(src, dst_latest)

    rel_copied = str(dst_copied.relative_to(root))
    rel_latest = str(dst_latest.relative_to(root))
    return rel_copied, rel_latest


def update_tracker_row(
    tracker_rows: list[dict[str, str]],
    panel: str,
    image_filename: str,
    prompt_version: str,
    seed: int,
    copied_path: str,
) -> None:
    for row in tracker_rows:
        if (row.get("panel") or "").strip() != panel:
            continue
        row["tool"] = "ComfyUI"
        row["model"] = "sd_xl_base_1.0.safetensors"
        row["prompt_version"] = prompt_version
        row["seed"] = str(seed)
        row["image_candidate"] = image_filename
        row["selected"] = "no"
        row["notes"] = f"Auto fast-series candidate copied to {copied_path}"
        return
    raise RuntimeError(f"Panel {panel} missing in tracker.")


def write_tracker(path: Path, rows: list[dict[str, str]]) -> None:
    if not rows:
        return
    headers = list(rows[0].keys())
    with path.open("w", encoding="utf-8", newline="") as f:
        writer = csv.DictWriter(f, fieldnames=headers)
        writer.writeheader()
        writer.writerows(rows)


def has_existing_fast_render(root: Path, panel: str, tracker_row: dict[str, str]) -> bool:
    prompt_version = (tracker_row.get("prompt_version") or "").strip().lower()
    image_candidate = (tracker_row.get("image_candidate") or "").strip().lower()
    notes = (tracker_row.get("notes") or "").strip().lower()
    if "fast" in prompt_version or "_fast_" in image_candidate or "fast preview" in notes or "fast-series" in notes:
        return True

    panel_dir = root / "production" / "selects" / panel
    if not panel_dir.exists():
        return False
    # If any prior candidates already exist, we can skip in fast mode.
    if any(panel_dir.glob(f"{panel}_candidate_*.png")):
        return True
    if (panel_dir / f"{panel}_candidate_latest.png").exists():
        return True
    return False


def main() -> int:
    args = parse_args()
    root = Path(__file__).resolve().parents[1]
    tracker_path = root / "production/refs/lookdev-tracker.csv"
    edl_path = root / "animatic/supertoys-edit-decision-list.csv"
    template_path = root / args.template

    tracker_rows = load_csv_rows(tracker_path)
    edl_rows = load_csv_rows(edl_path)
    tracker_by_panel = {row["panel"].strip(): row for row in tracker_rows if row.get("panel")}
    edl_by_panel = {row["panel"].strip(): row for row in edl_rows if row.get("panel")}

    if args.panels.strip():
        panels = [p.strip() for p in args.panels.split(",") if p.strip()]
    else:
        panels = pending_panels_from_tracker(tracker_rows)

    if not panels:
        print("No panels to submit.")
        return 0

    template = json.loads(template_path.read_text(encoding="utf-8"))

    notify_tone(args.notify, "FAST SERIES START")
    print(f"Submitting {len(panels)} fast panel workflows to {args.api_url}")
    results: list[tuple[str, str, str]] = []
    skipped: list[str] = []
    for panel in panels:
        if panel not in tracker_by_panel:
            print(f"[skip] {panel}: missing in tracker")
            continue

        tracker_row = tracker_by_panel[panel]
        if not args.force and has_existing_fast_render(root, panel, tracker_row):
            print(f"[skip] {panel}: existing fast render candidate found (use --force to rerender)")
            skipped.append(panel)
            continue

        edl_row = edl_by_panel.get(panel, {})
        video_note = (edl_row.get("video_note") or "").strip()
        emotion = (tracker_row.get("emotion") or "").strip()

        wf = copy.deepcopy(template)
        wf["6"]["inputs"]["text"] = build_prompt(panel, video_note, emotion)
        wf["3"]["inputs"]["seed"] = panel_seed(panel)
        wf["9"]["inputs"]["filename_prefix"] = f"supertoys/{panel}_fast"

        payload = {"prompt": wf}
        seed = wf["3"]["inputs"]["seed"]
        print(f"[submit] {panel} seed={seed}")
        try:
            response = submit(args.api_url, payload)
        except urllib.error.URLError as exc:
            print(f"[error] {panel}: {exc}")
            return 2
        except json.JSONDecodeError:
            print(f"[error] {panel}: invalid JSON response")
            return 2

        prompt_id = response.get("prompt_id")
        if not prompt_id:
            print(f"[error] {panel}: missing prompt_id in response")
            return 2
        print(f"[queued] {panel} prompt_id={prompt_id}")

        # Wait for render completion and capture produced image filename.
        h_url = history_url_for(args.api_url, prompt_id)
        image_ref: tuple[str, str] | None = None
        while image_ref is None:
            time.sleep(args.poll_seconds)
            try:
                history_payload = fetch_json(h_url)
            except urllib.error.URLError:
                continue
            image_ref = first_output_image(history_payload, prompt_id)

        subfolder, filename = image_ref
        print(f"[done] {panel} -> {subfolder}/{filename}")
        copied_path, latest_path = copy_candidate_image(root, panel, subfolder, filename)
        print(f"[copy] {panel} -> {copied_path} (latest: {latest_path})")
        update_tracker_row(
            tracker_rows,
            panel=panel,
            image_filename=filename,
            prompt_version="auto-fast-series-v1",
            seed=int(seed),
            copied_path=copied_path,
        )
        results.append((panel, filename, copied_path))
        notify_tone(args.notify, f"{panel} COMPLETE")

    write_tracker(tracker_path, tracker_rows)
    # Keep script+stills log in sync automatically.
    subprocess.run(
        ["python3", str(root / "scripts/sync_script_stills_log.py")],
        check=True,
    )

    print("Series complete.")
    for panel, filename, copied_path in results:
        print(f"  - {panel}: {filename} -> {copied_path}")
    if skipped:
        print("Skipped (existing fast renders):")
        for panel in skipped:
            print(f"  - {panel}")
    notify_tone(args.notify, "FAST SERIES FINISH")
    return 0


if __name__ == "__main__":
    sys.exit(main())
