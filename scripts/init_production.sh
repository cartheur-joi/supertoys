#!/usr/bin/env bash
set -euo pipefail

mkdir -p production/stills
mkdir -p production/selects
mkdir -p production/audio/vo
mkdir -p production/audio/sfx
mkdir -p production/audio/music
mkdir -p production/audio/mix
mkdir -p production/blender
mkdir -p production/exports
mkdir -p production/refs
mkdir -p production/submission/metadata
mkdir -p production/submission/promo
mkdir -p production/submission/subtitles
mkdir -p production/submission/legal

echo "Created/verified production folder structure under ./production"
