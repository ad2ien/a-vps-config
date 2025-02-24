# Mediamtx

## Test config

```bash
SECURED_URL="rtmps://$HOST:1936/live/test?user=$USER&pass=$PASSWORD"
UNSECURED_URL="rtmp://$HOST:1935/live/test?user=$USER&pass=$PASSWORD"
ffmpeg -re -i TestFile.mkv -c:v libx264 -c:a aac -f flv $SECURED_URL;
```

Same URL to read the stream e.g. with VLC / Open network stream
