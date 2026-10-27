#!/usr/bin/env bash
# Generate long sleep-noise MP3s for playback from a speaker's microSD card.
# Streams ffmpeg's noise generator straight into the MP3 encoder (no WAV).
#
# Usage: ./make_noise.sh [out_dir] [duration_seconds]
#   defaults: ./out, 43200 (12 h)
set -euo pipefail

OUT_DIR="${1:-./out}"
DURATION="${2:-43200}"
FADE_IN=30        # seconds
BITRATE=128k      # mono CBR
RATE=44100

# colour:amplitude — amplitudes calibrated so all tracks measure ~-21 LUFS
# after the 40 Hz highpass, i.e. switching tracks keeps the same loudness.
TRACKS=(
  "01:white:0.107"
  "02:pink:0.49"
  "03:brown:0.547"
)

mkdir -p "$OUT_DIR"

for t in "${TRACKS[@]}"; do
  IFS=: read -r num colour amp <<<"$t"
  out="$OUT_DIR/${num}_${colour}.mp3"
  echo "Generating $out (${DURATION}s)..."
  ffmpeg -hide_banner -loglevel error -y \
    -f lavfi -i "anoisesrc=color=${colour}:sample_rate=${RATE}:amplitude=${amp}:duration=${DURATION}:seed=${num#0}" \
    -af "highpass=f=40,afade=t=in:d=${FADE_IN},alimiter=limit=0.89:level=disabled" \
    -ac 1 -ar "$RATE" -c:a libmp3lame -b:a "$BITRATE" \
    -id3v2_version 3 -metadata title="${colour^} noise" -metadata track="${num#0}" \
    "$out" &
done
wait
echo "Done:"
ls -lh "$OUT_DIR"
