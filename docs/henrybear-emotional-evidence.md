# HenryBear Emotional Evidence

This page exposes the HenryBear runtime emotional evidence outputs for Supertoys documentation and GitHub Pages publishing.

Source repository: [cartheur-joi/henry-bear](https://github.com/cartheur-joi/henry-bear)

## Emotional Evidence

HenryBear produces an emotional evidence bundle from runtime signals and learning state snapshots.

- Default output root: `interactive-toys/bin/Debug/net9.0/artifacts/emotion-evidence`
- Bundle output format: `emotion-evidence-YYYYMMDD-HHMMSS/`
- Bundle files:
  - `evidence.json`
  - `timeline.csv`
  - `diagram.svg`
  - `manifest.sha256.json`
- Viewer: [`emotion-evidence-viewer/README.md`](https://github.com/cartheur-joi/henry-bear/blob/main/emotion-evidence-viewer/README.md)

## Emotional Diagram (Sample)

The evidence diagram is the visual summary artifact intended for review and validation.

![Emotion Evidence Sample](assets/emotion-evidence-sample.svg)

## Validate HenryBear Build (Reference)

Voice regression:

```bash
./interactive-toys/henry-test-voice.sh
./interactive-toys/henry-test-voice.sh "how are you"
```

Animals regression:

```bash
dotnet run --project animals-tests/Cartheur.Animals.Tests.csproj
```

## Notes

This page mirrors and reframes the emotional evidence section from HenryBear's `README.md` for publication in the Supertoys docs surface.
