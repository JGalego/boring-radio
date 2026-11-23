# boring radio

An internet radio station for your Suno songs inspired by Terry Godier's [The Boring Internet](https://www.terrygodier.com/the-boring-internet).

    sudo apt install icecast2 ffmpeg
    ./fetch.sh 2    # or copy your Suno mp3s into songs/ by hand
    ICECAST_PASSWORD=... ./radio.sh

Listen at http://localhost:8000/radio.  

Songs added to `songs/` join the next shuffle.

```
  Suno library
       |  Suno MCP (signed in through Claude Code)
       v
  +-------------------------+
  | fetch.sh                |  claude -p asks Suno for a download link,
  | claude -p + curl        |  curl saves the mp3
  +-------------------------+
       |
       v
  songs/*.mp3
       |
       v
  +-------------------------+
  | radio.sh                |  shuffle, re-encode to 128k MP3,
  | shuf + ffmpeg           |  push to Icecast
  +-------------------------+
       |
       v
  +-------------------------+
  | Icecast                 |  :8000/radio
  +-------------------------+
       |
       v
  your player
```
