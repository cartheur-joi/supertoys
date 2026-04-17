# ComfyUI Cost-Control Runbook

Use this when running on rented GPUs so we spend money only on useful renders.

## 1) Session Rules

- Keep one active goal per session: choose a single panel/emotion before starting a pod.
- Render previews first, finals second.
- Stop the pod as soon as output is exported/synced.
- Never leave a pod idle while writing prompts or reviewing story docs.

## 2) Start Session (Fast Iterate)

Terminal A:

```bash
make comfy-run-cpu-strong
```

Terminal B:

```bash
make comfy-p17-fast
```

`comfy-p17-fast` uses:
- 896x384 resolution
- 20 steps
- same composition prompt as HQ

## 3) Promote to Final (HQ)

After prompt/composition are approved from preview output:

```bash
make comfy-p17-hq
```

`comfy-p17-hq` uses:
- 1344x576 resolution
- 32 steps

## 4) Daily Spend Guardrails

- Target 70% preview runs, 30% HQ runs.
- Hard stop after 3 failed HQ attempts on one panel; return to fast mode.
- Batch review outputs in one pass to avoid rerendering from indecision.
- Keep a short notes log in `production/refs/lookdev-tracker.csv` (`prompt_version`, `seed`, `selected`).

## 5) End Session Checklist

```bash
ls -lah tools/ComfyUI/output/supertoys | tail -n 20
```

- Copy selected still(s) to `production/selects/`.
- Update `production/refs/lookdev-tracker.csv`.
- Shut down ComfyUI/pod immediately.

