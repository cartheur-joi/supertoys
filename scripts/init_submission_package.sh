#!/usr/bin/env bash
set -euo pipefail

ROOT="production/submission"
META_DIR="$ROOT/metadata"
PROMO_DIR="$ROOT/promo"
SUB_DIR="$ROOT/subtitles"
LEGAL_DIR="$ROOT/legal"

mkdir -p "$META_DIR" "$PROMO_DIR" "$SUB_DIR" "$LEGAL_DIR"

cat > "$META_DIR/logline.txt" <<'TXT'
In an artificial world where children are licensed and love is rationed, a synthetic boy and his teddy bear Henry try desperately to be loved before a new "real" baby replaces them.
TXT

cat > "$META_DIR/synopsis-short.txt" <<'TXT'
In a controlled near-future home, synthetic child Julian and his teddy bear Henry struggle to earn affection from emotionally distant adults. Their bond deepens as they face replacement by a biological child, forcing them to confront what "real" means.
TXT

cat > "$META_DIR/synopsis-long.txt" <<'TXT'
A SUMMER FOR SUPERTOYS is a bittersweet animated short set in a world where childhood and love are regulated commodities. Julian, a synthetic child, spends his days trying to be loved by Monica while Henry, his teddy bear companion, quietly mirrors and protects his emotional life. As David and Monica celebrate permission to have a biological child, Julian and Henry overhear their own disposability discussed from outside a window. The film closes on a question no machine or human can fully answer: what does "real" mean when loyalty and need are genuine?
TXT

cat > "$META_DIR/director-statement.md" <<'MD'
# Director Statement

A SUMMER FOR SUPERTOYS explores emotional authenticity in an engineered world. I wanted the film to feel intimate and restrained, with emotional weight carried by stillness, micro-gestures, and the fragile bond between Julian and Henry.

Rather than framing technology as spectacle, this short centers emotional evidence: who protects whom, who is seen, and who is treated as replaceable. The visual language contrasts warm garden tones with cold interiors to underscore that tension.

At its core, the film asks whether being "real" is a property of origin or of relationship.
MD

cat > "$META_DIR/credits.md" <<'MD'
# Credits

- Title: A SUMMER FOR SUPERTOYS
- Runtime: 03:00 (target)
- Country: TBD
- Year: 2026
- Language: English
- Subtitles: English
- Director: TBD
- Writer: TBD
- Producer: TBD
- Editor: TBD
- Music: TBD
- Sound Design: TBD
MD

cat > "$META_DIR/technical-specs.md" <<'MD'
# Technical Specs

- Final delivery file: `production/exports/supertoys_final.mp4`
- Container: MP4
- Video codec: H.264 (`libx264`)
- Resolution: 1920x1080 or higher
- Frame rate: 24 fps (target)
- Aspect ratio: 2.39:1 composited inside 16:9 container (target)
- Audio codec: AAC
- Audio mix target: -16 LUFS, max true peak -1 dBTP
- Runtime window: 2:50 to 3:10
MD

cat > "$META_DIR/rights-clearance-checklist.md" <<'MD'
# Rights Clearance Checklist

- [ ] Voice performance rights cleared
- [ ] Music license/original composition rights cleared
- [ ] SFX usage rights cleared
- [ ] Visual asset rights (models/images/fonts) cleared
- [ ] Third-party logos/trademarks removed or cleared
- [ ] Festival exhibition rights confirmed
MD

cat > "$SUB_DIR/supertoys_en.srt" <<'SRT'
1
00:00:00,000 --> 00:00:04,000
[Subtitle timing draft - replace with final timings]
SRT

cat > "$PROMO_DIR/README.md" <<'MD'
# Promo Assets Checklist

Add these files before submission:

- poster_1080x1600.jpg (or festival-specific poster format)
- still_01.jpg
- still_02.jpg
- still_03.jpg
- trailer_30_60s.mp4
MD

cat > "$LEGAL_DIR/README.md" <<'MD'
# Legal Deliverables

Store signed and final legal documents here:

- participant_release_forms.pdf
- music_license.pdf
- asset_license_log.csv
MD

echo "Created/verified submission package templates under $ROOT"
