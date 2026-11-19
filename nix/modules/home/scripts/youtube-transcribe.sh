if [[ $# -lt 1 || $# -gt 2 ]]; then
  echo 'Usage: youtube-transcribe <YouTube URL> [language]' >&2
  exit 2
fi

cache_dir="${XDG_CACHE_HOME:-$HOME/.cache}/web-fetch"
model_name=ggml-large-v3-q5_0.bin
model_path="$cache_dir/$model_name"
work_dir=$(mktemp -d)
model_download=
trap 'rm -rf -- "$work_dir"; if [[ -n "$model_download" ]]; then rm -f -- "$model_download"; fi' EXIT

audio=$(yt-dlp --no-playlist -f bestaudio --print after_move:filepath \
  -o "$work_dir/audio.%(ext)s" -- "$1")
ffmpeg -nostdin -v error -i "$audio" -ac 1 -ar 16000 -c:a pcm_s16le "$work_dir/audio.wav"

if [[ ! -s $model_path ]]; then
  mkdir -p -- "$cache_dir"
  model_download=$(mktemp "$cache_dir/$model_name.XXXXXXXX")
  curl -fsSL --retry 2 -o "$model_download" \
    "https://huggingface.co/ggerganov/whisper.cpp/resolve/main/$model_name"
  printf '%s  %s\n' d75795ecff3f83b5faa89d1900604ad8c780abd5739fae406de19f23ecd98ad1 \
    "$model_download" | sha256sum --check --status
  mv -f -- "$model_download" "$model_path"
fi

whisper-cli -m "$model_path" -l "${2:-auto}" -f "$work_dir/audio.wav" \
  -osrt -of "$work_dir/transcript" >&2
if [[ ! -s "$work_dir/transcript.srt" ]]; then
  echo 'Whisper returned no subtitles.' >&2
  exit 1
fi
cat "$work_dir/transcript.srt"
