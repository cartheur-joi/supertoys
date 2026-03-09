# Emotional Stills Shortlist

Use this to craft look-and-feel quickly before full animation.

## Top 8 Stills to Render First

1. `P17` - Monica interrogates Henry  
Emotion: tension, betrayal, maternal fear  
Goal: emotionally sharp confrontation frame

2. `P20` - Monica collapses with falling letters  
Emotion: grief release  
Goal: strongest sorrow image in the short

3. `P25` - Window split (toys outside, adults inside)  
Emotion: separation, exclusion  
Goal: core thematic poster frame

4. `P27` - David bends/crushes rose stem  
Emotion: silent pain  
Goal: symbolic close-up

5. `P28` - Henry steps in front of David  
Emotion: protection, loyalty  
Goal: Henry hero shot

6. `P30` - David asks “Are they real?”  
Emotion: existential fear  
Goal: intimate character portrait

7. `P31` - Henry and David hand clasp  
Emotion: reassurance  
Goal: emotional recovery beat

8. `P32` - Night nursery final tableau  
Emotion: fragile peace  
Goal: ending key art frame

## Prompt Source

Use the matching panel prompts from:
- `animatic/supertoys-still-prompts-midjourney-sdxl.md`

Initialize a tracking sheet:

```bash
make lookdev-init
```

Output:
- `production/refs/lookdev-tracker.csv`

Recommended first-pass workflow:
1. Generate 8 shortlisted panels
2. Pick 1 favorite per panel
3. Do light cleanup in Krita
4. Establish final color bible from these 8 images

## Where To Generate Stills

## Best for control + consistency (recommended)

1. Local `ComfyUI` + SDXL models on your Debian machine  
Why: reproducible seeds, workflow control, no subscription lock-in.

Starter links:
- ComfyUI repo: https://github.com/comfyanonymous/ComfyUI
- Comfy site: https://www.comfy.org/
- SDXL model cards:  
  - https://huggingface.co/stabilityai/stable-diffusion-xl-base-0.9  
  - https://huggingface.co/stabilityai/stable-diffusion-xl-refiner-0.9

## Fast style exploration (cloud)

2. Midjourney (quick style ideation)  
https://www.midjourney.com/

3. Leonardo AI (image + motion-friendly creative tooling)  
https://leonardo.ai/

## Practical recommendation for this project

1. Use Midjourney or Leonardo for rapid visual exploration (first mood pass).  
2. Lock final look in local ComfyUI + SDXL for consistent batch generation of story panels.  
3. Paint final touchups in Krita before importing to Blender.

## First Local Still Test (P17)

Run on the machine where you want to generate:

```bash
make comfy-bootstrap
```

Default clone source for bootstrap:
- `https://github.com/cartheur-joi/ComfyUI.git`

Override (if needed):

```bash
COMFY_REPO=https://github.com/comfyanonymous/ComfyUI.git make comfy-bootstrap
```

Then place checkpoint file in:
- `tools/ComfyUI/models/checkpoints/sd_xl_base_1.0.safetensors`

Start ComfyUI API:

```bash
cd tools/ComfyUI
source .venv/bin/activate
python main.py --listen 127.0.0.1 --port 8188
```

In a second terminal, submit the P17 workflow:

```bash
make comfy-p17
```

Workflow file:
- `tools/comfy-workflows/p17-emotional-still.json`

## Consistency Rules

- Keep a fixed seed family per sequence:
  - Nursery emotional beats: seed set A
  - Corporate scenes: seed set B
  - Dusk/night ending: seed set C
- Keep character descriptors identical between prompts.
- Reduce stylization once the look is approved.
- Save prompt + seed metadata per final panel.
- Mark `selected=yes` when a panel candidate is approved.
