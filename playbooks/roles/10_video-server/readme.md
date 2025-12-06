# Mediamtx

## Stream something

Customzie the following script

```bash
#!/bin/bash

set -e

echo "Start webcam stream task..."

while true; do
  if ping -c 1 $BASE_URL &> /dev/null
  then
    echo "connection ok"
    break
  else
    echo "waiting to be online..."
  fi
  sleep 5
done

ffmpeg -f v4l2 -framerate 5 -video_size 800x600 -i /dev/video0 \
-vcodec libx264 -preset medium -f flv \
"rtmps://$BASE_URL:1936/live/cam1?user=$USER&pass=$PASSWORD"

echo "end stream process"

```

Same URL to read the stream e.g. with VLC / Open network stream
