# START HERE - Supertoys

If you are returning later or starting on a fresh machine, follow this exact order.

## 1) Setup (new machine only)

```bash
git clone <your-repo-url>
cd supertoys
sudo apt update
sudo apt install -y blender krita audacity ffmpeg ardour zip git curl wget unzip python3 python3-venv
make init
make check-tools
make status
```

## 2) Read in this order (15-25 min)

1. [README.md](/home/cartheur/ame/aiventure/aiventure-github/cartheur-joi/supertoys/README.md)
2. [OPEN_SOURCE_ANIMATION_GUIDE_DEBIAN.md](/home/cartheur/ame/aiventure/aiventure-github/cartheur-joi/supertoys/docs/OPEN_SOURCE_ANIMATION_GUIDE_DEBIAN.md)
3. [supertoys-animated-screenplay.md](/home/cartheur/ame/aiventure/aiventure-github/cartheur-joi/supertoys/story/supertoys-animated-screenplay.md)
4. [animatic/README.md](/home/cartheur/ame/aiventure/aiventure-github/cartheur-joi/supertoys/animatic/README.md)
5. [animatic/supertoys-edit-decision-list.csv](/home/cartheur/ame/aiventure/aiventure-github/cartheur-joi/supertoys/animatic/supertoys-edit-decision-list.csv)

## Master Story Rule

- The canonical source is `story/animated-story-adaptation.md`.
- After any story/dialogue edit there, run:

```bash
make sync-master
```

- This regenerates:
  - `story/supertoys-animated-screenplay.md`
  - `planning/supertoys-voice-actor-script.md`
  - `planning/supertoys-voiceover-shotlist-3min.md`
  - `planning/supertoys-voiceover-shotlist-2min.md`
  - synced canon block in `planning/supertoys-storyboard-panel-checklist.md`

- For automatic sync on each save (and automatic diff output):

```bash
sudo apt install -y inotify-tools
make watch-master
```

## 3) First working session checklist

1. Generate/select stills for key panels: `P07, P17, P25, P32`
2. Build first timeline cut from `animatic/supertoys-edit-decision-list.csv`
3. Record VO using `planning/supertoys-voice-actor-script.md`
4. Export first review cut:

```bash
make review MASTER_MOV=production/exports/supertoys_master.mov
```

## 4) Daily operating commands

```bash
make status
make sync-master
make review MASTER_MOV=production/exports/supertoys_master.mov
make final MASTER_MOV=production/exports/supertoys_master.mov
make audio-check MIX_WAV=production/audio/mix/supertoys_mix_v01.wav
make package
```

## 5) Where everything lives

- Story docs: `story/`
- Planning docs: `planning/`
- Source assets: `source/` and `assets/`
- Animatic specs + prompts: `animatic/`
- General docs: `docs/`
- Automation scripts: `scripts/`
- Generated working files: `production/`
