# Supertoys Script + Stills Log

Living output file to track script beats and selected stills as we generate panels.

> Last synced: 2026-04-17 19:50

## Script Sources

- Narrative script: `planning/supertoys-voice-actor-script.md`
- Story screenplay: `reporting/supertoys-animated-screenplay.md`
- Timing + shot intent: `animatic/supertoys-edit-decision-list.csv`

## Panel Log (Rolling)

| Panel | Time | Script/Shot Beat | Selected Still | Status | Notes |
|---|---|---|---|---|---|
| P17 | 00:01:15-00:01:22 | Monica interrogates Henry | `production/selects/P17/P17_select.png` | selected | tool `ComfyUI`; model `sd_xl_base_1.0.safetensors`; prompt `p17-emotional-still`; seed `42001717`; candidate `P17_00001_.png`; HQ pass selected from tools/ComfyUI/output/supertoys |
| P20 | 00:01:33-00:01:40 | Monica breakdown high angle | `TBD` | pending |   |
| P25 | 00:02:05-00:02:12 | Window inside-outside split | `TBD` | pending |   |
| P27 | 00:02:20-00:02:28 | Rose stem bends in hand | `TBD` | pending |   |
| P28 | 00:02:28-00:02:35 | Henry shields David | `TBD` | pending |   |
| P30 | 00:02:42-00:02:48 | Profile question closeup | `TBD` | pending |   |
| P31 | 00:02:48-00:02:55 | Hand clasp chest light steady | `TBD` | pending |   |
| P32 | 00:02:55-00:03:00 | Night nursery final tableau | `TBD` | pending |   |
| P01 | 00:00:00-00:00:04 | Wide aerial garden reveal | `TBD` | pending |   |
| P07 | 00:00:25-00:00:30 | Henry paw on letter | `TBD` | pending | tool `ComfyUI`; model `sd_xl_base_1.0.safetensors`; prompt `p07-support-still-fast`; seed `42000707`; candidate `P07_fast_00001_.png`; Fast preview candidate copied to production/selects/P07/P07_candidate_fast_00001.png |
| P19 | 00:01:27-00:01:33 | Drawer reveal letters | `TBD` | pending |   |
| P23 | 00:01:51-00:01:58 | Ministry notice insert | `TBD` | pending |   |

## Update Rule

1. Select stills into `production/selects/<PANEL>/<PANEL>_select.png`
2. Update `production/refs/lookdev-tracker.csv` metadata
3. Run `make script-stills-sync` to refresh this file
