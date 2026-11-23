#!/bin/sh
# Fetch new songs from your Suno library into songs/, using the Suno MCP in Claude Code.
#   ./fetch.sh      list the new songs (downloads nothing, costs nothing)
#   ./fetch.sh N    download up to N of them (each uses one Suno download credit)
n=${1:-0}
case $n in '' | *[!0-9]*) echo "usage: $0 [N]" >&2; exit 2 ;; esac
cd "$(dirname "$0")" || exit

find="List my Suno songs that are not downloaded yet and are at least 120 seconds long.
Page through library-list (limit 50, follow next_cursor); a song is downloaded if it
appears in library-list with downloaded=true. Newest first."

if [ "$n" -eq 0 ]; then
  exec claude -p "$find Print one line per song: id, duration in seconds, title. Nothing else." \
    --allowedTools mcp__suno__library-list
fi

out=$(claude -p "$find Take the newest $n. For each, call audio-download (mp3) without confirm;
if it answers requires_credit, call it again with confirm true. Spend at most $n credits in
total. Print one line per song that succeeded, exactly: <id> <url>. Nothing else." \
  --allowedTools mcp__suno__library-list mcp__suno__audio-download) || exit

printf '%s\n' "$out" | while read -r id url; do
  case $id in '' | *[!0-9a-f-]*) continue ;; esac
  case $url in https://*) curl -fsS -o "songs/$id.mp3" "$url" && echo "songs/$id.mp3" ;; esac
done
