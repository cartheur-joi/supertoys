## supertoys

An adaptation workspace for turning *A Summer for Supertoys* into an animated short, with a single master story workboard (`story/workboard.md`) that syncs screenplay, VO, and planning outputs.

### Why This Project

We are building this to turn a strong emotional science-fiction premise into a focused animated story pipeline:
- keep one clear canonical source (`story/workboard.md`)
- avoid drift between story, screenplay, and production planning
- move quickly from writing decisions to animatic-ready assets
- preserve the emotional core of the child-and-bear relationship while iterating production choices safely
- deeply explore what emotional toys (`emotional.toys`) feel, fear, and need when they are treated as replaceable

### Start

1. Read [START_HERE.md](https://github.com/cartheur-joi/supertoys/blob/main/docs/START_HERE.md)
2. Then open [PROJECT_INDEX.md](https://github.com/cartheur-joi/supertoys/blob/main/docs/PROJECT_INDEX.md)
3. Run:

```bash
make init
make check-tools
make status
make sync-master
```

### Production Docs

- Start guide: [START_HERE.md](https://github.com/cartheur-joi/supertoys/blob/main/docs/START_HERE.md)
- Full file map: [PROJECT_INDEX.md](https://github.com/cartheur-joi/supertoys/blob/main/docs/PROJECT_INDEX.md)
- Main Debian guide: [OPEN_SOURCE_ANIMATION_GUIDE_DEBIAN.md](https://github.com/cartheur-joi/supertoys/blob/main/docs/OPEN_SOURCE_ANIMATION_GUIDE_DEBIAN.md)
- Makefile quickstart: [QUICKSTART_MAKE.md](https://github.com/cartheur-joi/supertoys/blob/main/docs/QUICKSTART_MAKE.md)
- Animatic package index: [animatic/README.md](https://github.com/cartheur-joi/supertoys/blob/main/animatic/README.md)

### Core Story Files

- Source story doc: [A summer for supertoys.docx](https://github.com/cartheur-joi/supertoys/blob/main/source/A%20summer%20for%20supertoys.docx)
- Workboard (master): [workboard.md](https://github.com/cartheur-joi/supertoys/blob/main/story/workboard.md)
- Screenplay draft (generated): [supertoys-animated-screenplay.md](https://github.com/cartheur-joi/supertoys/blob/main/reporting/supertoys-animated-screenplay.md)

### Master Sync

- Master file: `story/workboard.md`
- After story/dialogue edits to the master file, run:

```bash
make sync-master
```

- For automatic behavior on every save (diff + make):

```bash
make watch-master
```

### Background

"A summer for supertoys" is an anonymous science fiction short story.
