# Supertoys Script + Stills Log

Living output file to track script beats and selected stills as we generate panels.

> Last synced: 2026-04-17 20:51

## Script Sources

- Narrative script: `planning/supertoys-voice-actor-script.md`
- Story screenplay: `reporting/supertoys-animated-screenplay.md`
- Timing + shot intent: `animatic/supertoys-edit-decision-list.csv`

## Panel Log (Rolling)

| Panel | Time | Script/Shot Beat | Selected Still | Status | Notes |
|---|---|---|---|---|---|
| P17 | 00:01:15-00:01:22 | Monica interrogates Henry | `production/selects/P17/P17_select.png` | selected | tool `ComfyUI`; model `sd_xl_base_1.0.safetensors`; prompt `p17-emotional-still`; seed `42001717`; candidate `P17_00001_.png`; HQ pass selected from tools/ComfyUI/output/supertoys |
| P20 | 00:01:33-00:01:40 | Monica breakdown high angle | `TBD` | pending | tool `ComfyUI`; model `sd_xl_base_1.0.safetensors`; prompt `auto-fast-series-v1`; seed `42002020`; candidate `P20_fast_00001_.png`; Saved snapshot candidates in production/selects/P20/ and mirrored to reporting/selects/P20_latest_output.png |
| P25 | 00:02:05-00:02:12 | Window inside-outside split | `TBD` | pending | tool `ComfyUI`; model `sd_xl_base_1.0.safetensors`; prompt `p25-separation-still-fast`; seed `42002525`; candidate `P25_fast_00001_.png`; Saved snapshot candidates in production/selects/P25/ and mirrored to reporting/selects/P25_latest_output.png |
| P27 | 00:02:20-00:02:28 | Rose stem bends in hand | `TBD` | pending | tool `ComfyUI`; model `sd_xl_base_1.0.safetensors`; prompt `auto-fast-series-v1`; seed `42002727`; candidate `P27_fast_00002_.png`; Auto fast-series candidate copied to production/selects/P27/P27_candidate_20260417_202703.png |
| P28 | 00:02:28-00:02:35 | Henry shields David | `TBD` | pending | tool `ComfyUI`; model `sd_xl_base_1.0.safetensors`; prompt `auto-fast-series-v1`; seed `42002828`; candidate `P28_fast_00002_.png`; Auto fast-series candidate copied to production/selects/P28/P28_candidate_20260417_202913.png |
| P30 | 00:02:42-00:02:48 | Profile question closeup | `TBD` | pending | tool `ComfyUI`; model `sd_xl_base_1.0.safetensors`; prompt `auto-fast-series-v1`; seed `42003030`; candidate `P30_fast_00002_.png`; Auto fast-series candidate copied to production/selects/P30/P30_candidate_20260417_203118.png |
| P31 | 00:02:48-00:02:55 | Hand clasp chest light steady | `TBD` | pending | tool `ComfyUI`; model `sd_xl_base_1.0.safetensors`; prompt `auto-fast-series-v1`; seed `42003131`; candidate `P31_fast_00002_.png`; Auto fast-series candidate copied to production/selects/P31/P31_candidate_20260417_203322.png |
| P32 | 00:02:55-00:03:00 | Night nursery final tableau | `TBD` | pending | tool `ComfyUI`; model `sd_xl_base_1.0.safetensors`; prompt `auto-fast-series-v1`; seed `42003232`; candidate `P32_fast_00002_.png`; Auto fast-series candidate copied to production/selects/P32/P32_candidate_20260417_203526.png |
| P01 | 00:00:00-00:00:04 | Wide aerial garden reveal | `TBD` | pending | tool `ComfyUI`; model `sd_xl_base_1.0.safetensors`; prompt `auto-fast-series-v1`; seed `42000101`; candidate `P01_fast_00001_.png`; Saved snapshot candidates in production/selects/P01/ and mirrored to reporting/selects/P01_latest_output.png |
| P07 | 00:00:25-00:00:30 | Henry paw on letter | `TBD` | pending | tool `ComfyUI`; model `sd_xl_base_1.0.safetensors`; prompt `p07-support-still-fast`; seed `42000707`; candidate `P07_fast_00001_.png`; Saved snapshot candidates in production/selects/P07/ and mirrored to reporting/selects/P07_latest_output.png |
| P19 | 00:01:27-00:01:33 | Drawer reveal letters | `TBD` | pending | tool `ComfyUI`; model `sd_xl_base_1.0.safetensors`; prompt `auto-fast-series-v1`; seed `42001919`; candidate `P19_fast_00001_.png`; Saved snapshot candidates in production/selects/P19/ and mirrored to reporting/selects/P19_latest_output.png |
| P23 | 00:01:51-00:01:58 | Ministry notice insert | `TBD` | pending |   |

## Update Rule

1. Select stills into `production/selects/<PANEL>/<PANEL>_select.png`
2. Update `production/refs/lookdev-tracker.csv` metadata
3. Run `make script-stills-sync` to refresh this file
