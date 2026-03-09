# Supertoys Open-Source Animation Guide (AMD64 Debian)

This document consolidates the full recommended workflow for producing your `A Summer for Supertoys` animated short using open-source tools on an amd64 Debian machine.

## Goal

Produce a 2-4 minute emotional sci-fi short from your existing story package, using a practical solo-friendly pipeline.

Primary method: **2.5D animatic-to-film pipeline in Blender**  
Reason: best quality-to-effort ratio for short-form narrative without requiring full 3D character rigging.

---

## Recommended Toolchain

## Core tools

1. `Blender`  
Use for sequence edit, camera moves, 2.5D layout, final render.

2. `Krita`  
Use for image cleanup and layer separation (foreground/mid/background/character parts).

3. `Audacity` and/or `Ardour`  
Use for voice cleanup, SFX timing, music balance, final mix.

4. `FFmpeg`  
Use for final encodes and delivery formats.

## Optional but useful

1. `ComfyUI + SDXL`  
Use for local still generation and variations.

2. `Rhubarb Lip Sync`  
Use for quick mouth-shape timing if adding speaking closeups.

---

## Install on Debian (AMD64)

Estimated time: **1-2 hours**

```bash
sudo apt update
sudo apt install -y blender krita audacity ffmpeg ardour git curl wget unzip python3 python3-venv
```

## If You Are Setting Up Another Computer Later

Use this exact sequence on the new Debian amd64 machine:

```bash
# 1) clone
git clone <your-repo-url>
cd supertoys

# 2) install baseline tools
sudo apt update
sudo apt install -y blender krita audacity ffmpeg ardour zip git curl wget unzip python3 python3-venv

# 3) initialize production folders
make init

# 4) verify tooling
make check-tools

# 5) verify project readiness
make status
```

If `make check-tools` reports missing packages, install them and rerun `make check-tools` until all are found.

Notes:
- Debian repo versions may lag behind latest releases.
- If you need newer Blender/Krita, install official binaries in user space.
- Keep project assets in this repo and cache heavy generation models on a larger drive if available.

---

## Existing Project Assets (Use These as Source of Truth)

From this repo:

1. [supertoys-animated-screenplay.md](/home/cartheur/ame/aiventure/aiventure-github/cartheur-joi/supertoys/reporting/supertoys-animated-screenplay.md)
2. [supertoys-voiceover-shotlist-3min.md](/home/cartheur/ame/aiventure/aiventure-github/cartheur-joi/supertoys/planning/supertoys-voiceover-shotlist-3min.md)
3. [supertoys-voiceover-shotlist-2min.md](/home/cartheur/ame/aiventure/aiventure-github/cartheur-joi/supertoys/planning/supertoys-voiceover-shotlist-2min.md)
4. [supertoys-voice-actor-script.md](/home/cartheur/ame/aiventure/aiventure-github/cartheur-joi/supertoys/planning/supertoys-voice-actor-script.md)
5. [supertoys-storyboard-panel-checklist.md](/home/cartheur/ame/aiventure/aiventure-github/cartheur-joi/supertoys/planning/supertoys-storyboard-panel-checklist.md)
6. [animatic/supertoys-still-prompts-midjourney-sdxl.md](/home/cartheur/ame/aiventure/aiventure-github/cartheur-joi/supertoys/animatic/supertoys-still-prompts-midjourney-sdxl.md)
7. [animatic/supertoys-audio-timing-sheet-3min.md](/home/cartheur/ame/aiventure/aiventure-github/cartheur-joi/supertoys/animatic/supertoys-audio-timing-sheet-3min.md)
8. [animatic/supertoys-edit-decision-list.csv](/home/cartheur/ame/aiventure/aiventure-github/cartheur-joi/supertoys/animatic/supertoys-edit-decision-list.csv)
9. [animatic/supertoys-production-checklist.md](/home/cartheur/ame/aiventure/aiventure-github/cartheur-joi/supertoys/animatic/supertoys-production-checklist.md)

---

## Total Time Expectations

## Fast animatic only
- **12-20 hours**

## Polished 2.5D short
- **35-70 hours**

Time depends mostly on:
- how many shots get layered/parallax treatment
- how much character micro-animation you add
- how polished your sound mix is

---

## Phase-by-Phase Plan (with Time)

## Phase 1: Setup and Project Structure

Estimated time: **30-60 min**

Create folders:

```bash
mkdir -p production/{stills,selects,audio/{vo,sfx,music,mix},blender,exports,refs}
```

Recommended naming:
- `P##_v##_seed####.png` for generated stills
- `P##_select.png` for approved panels
- `supertoys_vo_v01.wav`, `supertoys_mix_v01.wav`
- `supertoys_animatic_v01_YYYYMMDD.mp4`

---

## Phase 2: Still Generation and Selection

Estimated time: **4-12 hours**

1. Generate all 36 panels (or start with key shots first).
2. Select one hero still per panel.
3. Correct continuity issues in Krita:
- Henry face consistency
- David age/wardrobe consistency
- lighting continuity across sequences

Priority keyframes:
- `P07`, `P17`, `P25`, `P32`

---

## Phase 3: Build First Animatic in Blender VSE

Estimated time: **2-4 hours**

1. Open Blender `Video Editing` workspace.
2. Import `P##_select.png` stills.
3. Apply timing from `animatic/supertoys-edit-decision-list.csv`.
4. Add subtle movement:
- 2-5% push-in on static shots
- occasional lateral drift
5. Export first visual cut.

Checkpoint output:
- `production/exports/supertoys_animatic_v01.mp4`

---

## Phase 4: Voiceover and Temp Audio

Estimated time: **2-5 hours**

1. Record narration from [supertoys-voice-actor-script.md](/home/cartheur/ame/aiventure/aiventure-github/cartheur-joi/supertoys/planning/supertoys-voice-actor-script.md).
2. Record at least 3 takes:
- neutral
- more grief
- softer hopeful ending
3. Clean VO in Audacity:
- noise reduction (light)
- compression (gentle)
- normalize peaks
4. Place VO against timeline using [animatic/supertoys-audio-timing-sheet-3min.md](/home/cartheur/ame/aiventure/aiventure-github/cartheur-joi/supertoys/animatic/supertoys-audio-timing-sheet-3min.md).

---

## Phase 5: 2.5D Shot Construction

Estimated time: **8-20 hours**

For each important shot:
1. Split still in Krita into layers:
- background
- midground
- character
- foreground overlays
2. Export transparent PNG layers.
3. In Blender:
- place layers on separate planes (Z-depth spacing)
- animate camera for parallax
- keep moves slow, story-first

Prioritize emotional shots:
- `P07`, `P17`, `P20`, `P25`, `P28`, `P32`

---

## Phase 6: Character Micro-Animation

Estimated time: **8-16 hours**

Add only small, meaningful motion:
- blink
- breath
- slight head turns
- hand/paw squeeze
- Henry chest-light pulse pattern

Rules:
- avoid constant motion
- emphasize stillness and emotional beats
- only animate what adds story value

---

## Phase 7: Optional Lip Sync

Estimated time: **2-6 hours**

Use Rhubarb for close dialogue shots only.

Suggested approach:
1. Generate mouth timing data from dialogue clips.
2. Apply 2D mouth-shape swaps in Blender.
3. Skip distant shots to save time.

---

## Phase 8: Final Sound Design and Mix

Estimated time: **3-8 hours**

Use stems:
- VO
- SFX
- music

Targets:
- temp web mix around `-16 LUFS`
- true peak <= `-1 dBTP`

Audio priorities:
1. VO clarity first
2. SFX accents on turning points only
3. music supports mood, never masks dialogue

---

## Phase 9: Render and Deliverables

Estimated time: **2-6 hours** (depending on settings/hardware)

Blender export:
- render image sequence or mezzanine video
- verify no dropped frames

FFmpeg delivery encode:

```bash
ffmpeg -i production/exports/supertoys_master.mov \
  -c:v libx264 -crf 18 -preset slow -pix_fmt yuv420p \
  -c:a aac -b:a 192k \
  production/exports/supertoys_final.mp4
```

Optional quick review encode:

```bash
ffmpeg -i production/exports/supertoys_master.mov \
  -c:v libx264 -crf 24 -preset veryfast -pix_fmt yuv420p \
  -c:a aac -b:a 128k \
  production/exports/supertoys_review.mp4
```

---

## Suggested 5-Day Schedule

## Day 1 (6-8h)
- Install tools
- organize folders
- generate/select key stills

## Day 2 (6-8h)
- complete still selection
- build timeline with CSV timings
- export animatic v01

## Day 3 (6-10h)
- record and clean VO
- add temp SFX/music
- lock animatic timing v02

## Day 4 (8-12h)
- 2.5D layer separations in Krita
- parallax camera for priority shots

## Day 5 (8-12h)
- micro-animation pass
- final mix
- render + delivery exports

---

## Quality Checklist Before Final Export

1. Character continuity stable across all panels.
2. Lighting continuity consistent per sequence.
3. Shot transitions feel intentional, not abrupt.
4. VO fully intelligible on laptop speakers and headphones.
5. Ending holds long enough emotionally (at least 1.5-2.0 seconds including tail).
6. Final runtime in target range.

---

## Practical Scope Advice

If time is tight, prioritize:
1. Strong stills
2. Good VO
3. Good pacing
4. Minimal but precise motion

This yields a strong film faster than attempting full character rig animation.

---

## What “Most Open-Source” Means Here

Fully open-source production path:
- Blender + Krita + Audacity/Ardour + FFmpeg (+ optional Rhubarb)

If you also use Midjourney for stills, the pipeline is still mostly open-source for production, but not fully open-source end-to-end image generation.  
For fully open generation, use local SDXL/ComfyUI workflows.
