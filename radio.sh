#!/bin/sh
# Shuffle songs/*.mp3 forever into one 128k MP3 stream on the local Icecast.
: "${ICECAST_PASSWORD:?}"
cd "$(dirname "$0")/songs" || exit
trap 'kill 0' INT

while :; do
  shuf -e -- *.mp3 | while IFS= read -r song; do
    ffmpeg -v error -nostdin -i "$song" -vn -ar 44100 -ac 2 -b:a 128k \
      -id3v2_version 0 -write_xing 0 -f mp3 - || sleep 1
  done
done | while :; do
  ffmpeg -v error -re -f mp3 -i - -c copy -content_type audio/mpeg \
    -ice_name "Boring Radio" -password "$ICECAST_PASSWORD" \
    -f mp3 icecast://source@localhost:8000/radio
  sleep 5
done &
wait
