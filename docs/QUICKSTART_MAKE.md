# Supertoys Makefile Quickstart

Use this for a fast, repeatable workflow on Debian.

## New Machine Setup (Save This)

```bash
git clone <your-repo-url>
cd supertoys
sudo apt update
sudo apt install -y blender krita audacity ffmpeg ardour zip git curl wget unzip python3 python3-venv
make init
make check-tools
make status
```

## 1) Initialize folders

```bash
make init
```

## 2) Check required tools

```bash
make check-tools
```

## 3) See project readiness

```bash
make status
```

## 4) Sync all derivative writing docs from the master story file

Master file:
- `story/workboard.md`

Run:

```bash
make sync-master
```

Optional auto mode (on every save of master file):

```bash
sudo apt install -y inotify-tools
make watch-master
```

## 5) Create a review encode

Put your master file at:
- `production/exports/supertoys_master.mov`

Then run:

```bash
make review
```

Output:
- `production/exports/supertoys_review.mp4`

## 6) Create final delivery encode

```bash
make final
```

Output:
- `production/exports/supertoys_final.mp4`

## 7) Check loudness for your mix WAV

Put your mix at:
- `production/audio/mix/supertoys_mix_v01.wav`

Then run:

```bash
make audio-check
```

## 8) Package docs + animatic specs

```bash
make package
```

Output:
- `production/exports/supertoys_docs_animatic_YYYYMMDD.zip`

## Useful overrides

Use alternate paths without editing files:

```bash
make final MASTER_MOV=production/exports/custom_master.mov FINAL_MP4=production/exports/custom_final.mp4
make audio-check MIX_WAV=production/audio/mix/supertoys_mix_v02.wav
```
