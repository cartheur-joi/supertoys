# Masterfile Workflow

This repo uses one canonical story source:

- `story/workboard.md`

All downstream writing docs are generated from it.

## Manual Sync

After editing and saving the master file:

```bash
make sync-master
```

This regenerates:
- `reporting/supertoys-animated-screenplay.md`
- `planning/supertoys-voice-actor-script.md`
- `planning/supertoys-voiceover-shotlist-3min.md`
- `planning/supertoys-voiceover-shotlist-2min.md`
- Canon sync block in `planning/supertoys-storyboard-panel-checklist.md`

## Automatic Sync on Save

Install watcher dependency:

```bash
sudo apt install -y inotify-tools
```

Run:

```bash
make watch-master
```

Behavior on every save of `story/workboard.md`:
1. Shows diff from previous saved version of the master file.
2. Runs `make sync-master`.
3. Shows diffs for regenerated downstream files.

Stop watcher with `Ctrl+C`.

## Common Daily Loop

1. Edit `story/workboard.md`
2. Save file
3. Review diff output from watcher
4. If good, commit changes:

```bash
git add story/workboard.md reporting/supertoys-animated-screenplay.md planning/
git commit -m "Update story and synced planning docs"
```
