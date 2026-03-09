# Supertoys Animatic Package

This folder contains production-ready assets for a first-pass animatic:

- `supertoys-still-prompts-midjourney-sdxl.md`
  - 36 storyboard panels
  - One Midjourney prompt and one SDXL prompt per panel
  - Negative prompt and continuity notes
- `supertoys-audio-timing-sheet-3min.md`
  - 3:00 timeline with VO lines, SFX, music, and mix levels
- `supertoys-edit-decision-list.csv`
  - Shot list with in/out timecodes and durations for edit assembly

Recommended workflow:
1. Generate stills per panel with consistent seeds and style lock.
2. Drop shots into sequence using `supertoys-edit-decision-list.csv`.
3. Record VO from `../planning/supertoys-voice-actor-script.md`.
4. Build temp mix from `supertoys-audio-timing-sheet-3min.md`.
5. Export animatic v1 and review pacing before full animation.
