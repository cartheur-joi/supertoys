# Supertoys Animation Plan (Summary README)

This is the working summary for producing the 3-minute animatic and preparing festival submission.

## Project Goal

- Deliver a final short in the 2:50-3:10 range.
- Build from 36 planned storyboard panels.
- Complete submission-ready package (metadata, promo assets, tracker, zip handoff).

## Master Timeline (8 Weeks)

1. Week 1: Story lock + pipeline integrity  
   Source of truth: `story/workboard.md`  
   Sync command: `make sync-master`
2. Weeks 2-4: Visual production (36 panels)
3. Weeks 4-6: Edit + audio finishing
4. Weeks 6-8: Submission packaging + festival entries

Reference: `docs/PRODUCTION_PLAN_8WEEKS.md`

## Visual Production Strategy

- Generate hero continuity shots first:
  - `P07` support beat
  - `P17` confrontation beat
  - `P25` separation beat
  - `P32` ending tableau
- Then complete remaining panels by sequence blocks:
  - `P01-P04` Garden open
  - `P05-P12` Nursery bond
  - `P13-P16` Corporate contrast
  - `P17-P24` Conflict + lottery turn
  - `P25-P36` Reveal + ending

Reference: `animatic/supertoys-production-checklist.md`

## Render Workflow (Local-First)

1. Start ComfyUI:
   - `make comfy-run-cpu-strong`
2. Iterate in low-cost mode first:
   - Example: `make comfy-p07-fast`
3. Only run HQ once composition is approved:
   - Example: `make comfy-p07-hq`
4. Track and sync:
   - Update `production/refs/lookdev-tracker.csv`
   - Run `make script-stills-sync`

### Optional Unattended Mode

- Run all pending fast panels automatically:
  - `make comfy-fast-series`
- Skip behavior is default for already-rendered fast candidates.
- Force rerender when needed:
  - `make comfy-fast-series FORCE=1`

## Editing + Audio Plan

1. Assemble timeline from `animatic/supertoys-edit-decision-list.csv`
2. Record VO from `planning/supertoys-voice-actor-script.md`
3. Build SFX/music using `animatic/supertoys-audio-timing-sheet-3min.md`
4. Export and validate:
   - `make review`
   - `make audio-check`
   - `make final`

## Submission Plan

1. Fill package templates under `production/submission/`
2. Add poster/stills/trailer under `production/submission/promo/`
3. Maintain `reporting/supertoys-festival-submission-tracker.csv`
4. Validate + package:
   - `make submission-check`
   - `make submission-package`

## Current Status Snapshot (2026-04-17)

- `P17` selected: `production/selects/P17/P17_select.png`
- `P07` fast candidate generated; HQ still pending lock
- Remaining hero shots to advance in preview-first mode: `P25`, `P32`

Live progress log: `reporting/supertoys-script-stills-log.md`
