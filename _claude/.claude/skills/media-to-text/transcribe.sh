#!/usr/bin/env bash
# Transcribe every audio/video file in a directory (or a list of files) with whisper.cpp.
# Usage: bash transcribe.sh <out_dir> <dir-or-file>... [-l LANG]
# Writes <out_dir>/txt/<name>.txt per file and <out_dir>/all.txt (name-sorted, with durations).
set -euo pipefail
[[ $# -ge 2 ]] || { echo "usage: bash transcribe.sh <out_dir> <dir-or-file>... [-l LANG]" >&2; exit 2; }
out=$1; shift
lang=auto; inputs=()
while (($#)); do case $1 in -l) lang=$2; shift 2;; *) inputs+=("$1"); shift;; esac; done
model=${WHISPER_MODEL:-$HOME/.local/share/voxtype/models/ggml-large-v3-turbo.bin}
[[ -f $model ]] || { echo "model not found: $model (set WHISPER_MODEL)" >&2; exit 1; }
command -v whisper-cli >/dev/null && command -v ffmpeg >/dev/null || { echo "need whisper-cli and ffmpeg" >&2; exit 1; }
mkdir -p "$out/wav" "$out/txt"
list="$out/files.list"; : > "$list"
exts='ogg|oga|opus|mp3|m4a|aac|wav|flac|webm|mp4|mkv|mov|avi'
for i in "${inputs[@]}"; do
  if [[ -d $i ]]; then find "$i" -maxdepth 1 -type f -regextype posix-extended -iregex ".*\.($exts)$" -print0 | sort -z | tr '\0' '\n' >> "$list"
  else printf '%s\n' "$i" >> "$list"; fi
done
n=$(wc -l < "$list"); [[ $n -gt 0 ]] || { echo "no media files found" >&2; exit 1; }
cores=$(nproc); jobs=$(( n < 4 ? n : 4 )); threads=$(( cores / jobs )); (( threads < 1 )) && threads=1
echo "files=$n jobs=$jobs threads/job=$threads lang=$lang"
export out model lang threads
one() {
  f=$1; b=$(basename "${f%.*}")
  [[ -s $out/txt/$b.txt ]] && return 0   # resume: skip done files
  ffmpeg -nostdin -v error -y -i "$f" -vn -ar 16000 -ac 1 "$out/wav/$b.wav" &&
  whisper-cli -m "$model" -l "$lang" -t "$threads" -nt -np -otxt -of "$out/txt/$b" "$out/wav/$b.wav" >/dev/null 2>"$out/wav/$b.err" &&
  rm -f "$out/wav/$b.wav" || echo "FAILED: $f (see $out/wav/$b.err)" >&2
}
export -f one
tr '\n' '\0' < "$list" | xargs -0 -P "$jobs" -I{} bash -c 'one "$1"' _ {}
: > "$out/all.txt"; total=0
while IFS= read -r f; do
  b=$(basename "${f%.*}"); d=$(ffprobe -v error -show_entries format=duration -of csv=p=0 "$f" | cut -d. -f1)
  total=$((total + ${d:-0}))
  printf '=== %s (%d:%02d)\n' "$b" $((d/60)) $((d%60)) >> "$out/all.txt"
  if [[ -s $out/txt/$b.txt ]]; then tr -s ' \n' ' ' < "$out/txt/$b.txt" | sed 's/^ //' >> "$out/all.txt"; echo >> "$out/all.txt"
  else echo "[transcription failed]" >> "$out/all.txt"; fi
done < "$list"
echo "done: $n files, $((total/60)) min audio -> $out/all.txt"
