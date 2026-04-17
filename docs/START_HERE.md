# START HERE

This repo is an adaptation workspace for producing a 3-minute short animatic, then submitting it to festivals.

## 1) One-time setup

```bash
make init
make check-tools
make lookdev-init
make submission-init
```

## 2) Story workflow (source of truth)

- Edit only: `story/workboard.md`
- Regenerate derivatives:

```bash
make sync-master
```

- Optional watcher while writing:

```bash
make watch-master
```

## 3) Production workflow

1. Generate stills from `animatic/supertoys-still-prompts-midjourney-sdxl.md`
2. Track continuity in `production/refs/lookdev-tracker.csv`
3. Build timeline from `animatic/supertoys-edit-decision-list.csv`
4. Record VO from `planning/supertoys-voice-actor-script.md`
5. Mix to `animatic/supertoys-audio-timing-sheet-3min.md`
6. Encode outputs:

```bash
make review
make audio-check
make final
```

## 4) Submission workflow

- Fill metadata templates in `production/submission/metadata/`
- Add poster/stills/trailer in `production/submission/promo/`
- Update `reporting/supertoys-festival-submission-tracker.csv`
- Validate package:

```bash
make submission-check
```

- Zip handoff:

```bash
make submission-package
```

## 5) Core plan and index

- 8-week plan: `docs/PRODUCTION_PLAN_8WEEKS.md`
- Project map: `docs/PROJECT_INDEX.md`
