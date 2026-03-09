# Supertoys Animatic Production Checklist

## 1) Folder Structure

```text
animatic/
  stills/
    P01/
    P02/
    ...
  selects/
  sequence/
  audio/
    vo/
    sfx/
    music/
  exports/
```

## 2) File Naming Convention

- Stills: `P##_v##_seed####.png`
- Selects: `P##_select.png`
- Audio stems: `supertoys_vo_v01.wav`, `supertoys_sfx_v01.wav`, `supertoys_music_v01.wav`
- Exports: `supertoys_animatic_v01_YYYYMMDD.mp4`

## 3) Generation Order (Fastest Path)

Generate hero continuity panels first:
1. `P07` (David + Henry at desk)
2. `P17` (Monica + Henry confrontation)
3. `P25` (window separation shot)
4. `P32` (final nursery tableau)

Then generate remaining panels by sequence block:
1. `P01-P04` Garden open
2. `P05-P12` Nursery bond
3. `P13-P16` Corporate contrast
4. `P17-P24` Conflict + lottery turn
5. `P25-P36` Window reveal + ending

## 4) Quality Gates Per Panel

- Character identity consistency
- Costume continuity (especially David + Monica)
- Time-of-day coherence within sequence
- Correct emotional beat (from storyboard checklist)
- Readability of key props (letters, notice, rose)

## 5) Edit Assembly Steps

1. Import still selects and `supertoys-edit-decision-list.csv`.
2. Lay down stills to exact durations from CSV.
3. Add 2-5% push-ins to static shots for life.
4. Place VO temp from `planning/supertoys-voice-actor-script.md`.
5. Add SFX accents only on story pivots.
6. Add music bed and automate ducking under VO.
7. Export v1 and check emotional pacing.

## 6) Continuity Fails and Fixes

- Henry face drift:
  - Re-run with “worn golden teddy bear, visible stitch repairs, glass eyes, chest status light.”
- David age drift:
  - Add “seven-year-old synthetic boy, child proportions, soft features.”
- Style drift:
  - Reduce stylization; image-to-image from approved prior panel.
- Lighting mismatch:
  - Explicitly set “warm late-afternoon amber light” or “cool corporate cyan.”

## 7) Review Checklist Before v1 Export

- Total runtime within target (+/- 10 seconds)
- VO intelligibility clear on phone speakers
- No abrupt jumps in angle or lighting
- Ending holds long enough to land emotionally
- End card readable for at least 1.5 seconds
