# Supertoys 8-Week Production Plan (Animatic+, Festival-First)

## Week 1 - Story Lock + Pipeline Integrity

- Finalize canon in `story/workboard.md`.
- Run `make sync-master` after each approved story change.
- Enforce generated-doc policy: no manual edits in `planning/` and `reporting/` for synced sections.
- Confirm naming continuity on adult male parent as `David`.

Exit criteria:
- Story lock approved.
- Generated derivatives refreshed and committed.

## Weeks 2-4 - Visual Production (36 Panels)

- Initialize continuity tracker: `make lookdev-init`.
- Generate hero continuity shots first: P07, P17, P25, P32.
- Complete all panel stills by sequence blocks from `animatic/supertoys-production-checklist.md`.
- Select finals and save to `production/selects/`.

Exit criteria:
- 36 selected stills with continuity pass completed.

## Weeks 4-6 - Edit + Audio Finishing

- Assemble timeline from `animatic/supertoys-edit-decision-list.csv`.
- Record VO (3 passes) using `planning/supertoys-voice-actor-script.md`.
- Build SFX/music mix using `animatic/supertoys-audio-timing-sheet-3min.md`.
- Encode review and final deliverables:
  - `make review`
  - `make audio-check`
  - `make final`

Exit criteria:
- Final cut runtime in 2:50-3:10 window.
- Audio meets target loudness and peak constraints.
- Master output at `production/exports/supertoys_final.mp4`.

## Weeks 6-8 - Festival Package + Submission

- Prepare package under `production/submission/`:
  - Metadata: logline, synopses, statement, credits, specs.
  - Promo: poster, 3-10 stills, trailer.
  - Subtitles: English `.srt`.
  - Legal: rights and release documents.
- Initialize and maintain tracker:
  - `reporting/supertoys-festival-submission-tracker.csv`
- Validate package:
  - `make submission-check`

Submission order:
1. Clermont-Ferrand official route (via official regulations and accepted platform flow)
2. Shortfilmdepot listing/profile
3. FilmFreeway and Festhome targets

Exit criteria:
- At least 10 festival submissions recorded with IDs and dates.
- Submission package zipped with `make submission-package`.
