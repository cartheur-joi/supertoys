# Open Source Animation Guide (Debian)

## Install baseline tools

```bash
sudo apt update
sudo apt install -y python3 curl ffmpeg zip blender krita audacity ardour inotify-tools
```

## Validate environment

```bash
make check-tools
```

## Optional ComfyUI setup

```bash
make comfy-bootstrap
```

Then run ComfyUI locally:

```bash
cd tools/ComfyUI
source .venv/bin/activate
python main.py --listen 127.0.0.1 --port 8188
```

And submit a workflow from repo root:

```bash
make comfy-p17
```

## Encode helpers

- Review encode: `make review`
- Final encode: `make final`
- Loudness check: `make audio-check`
