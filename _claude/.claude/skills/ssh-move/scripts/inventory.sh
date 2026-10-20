#!/usr/bin/env bash
# Describe everything under a folder that a move has to carry.
#   bash inventory.sh <folder>              locally
#   ssh <host> bash -s -- <folder> < inventory.sh   on another machine
# <folder> is absolute or relative to $HOME. Paths printed are relative to it.
# Runs on macOS bash 3.2, so no mapfile or associative arrays.
#
# Output, one record per line, tab-separated:
#   root      <absolute path>  <home-relative path>  <mounted|plain>
#   repo      <path>
#   remote    <path>  <name>  <url>  <ssh hostname the url's host resolves to here>
#   head      <path>  <branch, or "detached <sha>">
#   branch    <path>  <name>  <sha>  <upstream or ->  <commits not on any remote>
#   dirty     <path>  <modified>  <untracked>  <deleted>
#   stash     <path>  <count>
#   extra     <path>  submodules|lfs|hooks|localconfig
#   worktree  <repo path>  <worktree path, home-relative if outside the folder>  <branch>  <dirty count>
#   dchome    <path>   a devcontainer home folder (logins) - copied
#   container <name>  <state>  <folder>   devcontainer whose project is inside the folder
set -uo pipefail

root=$1
[[ $root = /* ]] || root=$HOME/$root
root=${root%/}
[[ -d $root ]] || { echo "error	no such folder: $root"; exit 1; }
cd "$root" || exit 1

mounted=plain
if command -v mountpoint >/dev/null && mountpoint -q "$root"; then mounted=mounted; fi
for d in "$root" "$(dirname "$root")"; do
  if command -v mountpoint >/dev/null && mountpoint -q "$d"; then mounted=mounted; fi
done
printf 'root\t%s\t%s\t%s\n' "$root" "${root#$HOME/}" "$mounted"

rel() { local p=${1#$root/}; [[ $1 = "$root" ]] && p=.; echo "$p"; }
hostof() { # ssh host of a git url, empty for non-ssh urls
  case $1 in
    ssh://*) local h=${1#ssh://}; h=${h%%/*}; h=${h#*@}; echo "${h%%:*}" ;;
    *://*) ;;
    *:*) local h=${1%%:*}; echo "${h#*@}" ;;
  esac
}

find . -name .devcontainer-home -prune -type d 2>/dev/null | sed 's|^\./||' | while read -r h; do
  for d in "$h"/*/; do [[ -d $d ]] && printf 'dchome\t%s\n' "${d%/}"; done
done

find . \( -name node_modules -o -name .venv \) -prune -o -name .git -type d -prune -print 2>/dev/null |
  sed 's|^\./||; s|/\.git$||; s|^\.git$|.|' | sort | while read -r r; do
  g=(git -C "$root/$r")
  printf 'repo\t%s\n' "$r"
  "${g[@]}" remote | while read -r name; do
    url=$("${g[@]}" remote get-url "$name")
    h=$(hostof "$url"); real=-
    [[ -n $h ]] && real=$(ssh -G "$h" 2>/dev/null | awk '/^hostname /{print $2}')
    printf 'remote\t%s\t%s\t%s\t%s\n' "$r" "$name" "$url" "$real"
  done
  b=$("${g[@]}" symbolic-ref -q --short HEAD) || b="detached $("${g[@]}" rev-parse --short HEAD 2>/dev/null)"
  printf 'head\t%s\t%s\n' "$r" "$b"
  "${g[@]}" for-each-ref --format='%(refname:short)	%(objectname:short)	%(upstream:short)' refs/heads |
  while IFS=$'\t' read -r name sha up; do
    n=$("${g[@]}" rev-list --count "$name" --not --remotes 2>/dev/null)
    printf 'branch\t%s\t%s\t%s\t%s\t%s\n' "$r" "$name" "$sha" "${up:--}" "$n"
  done
  s=$("${g[@]}" status --porcelain=v1 2>/dev/null)
  printf 'dirty\t%s\t%s\t%s\t%s\n' "$r" \
    "$(grep -c '^ *[MARC]' <<<"$s")" "$(grep -c '^??' <<<"$s")" "$(grep -c '^ *D' <<<"$s")"
  n=$("${g[@]}" stash list 2>/dev/null | wc -l | tr -d ' ')
  [[ $n != 0 ]] && printf 'stash\t%s\t%s\n' "$r" "$n"
  [[ -f $root/$r/.gitmodules ]] && printf 'extra\t%s\tsubmodules\n' "$r"
  grep -qs 'filter=lfs' "$root/$r/.gitattributes" && printf 'extra\t%s\tlfs\n' "$r"
  ls "$root/$r/.git/hooks" 2>/dev/null | grep -qv '\.sample$' && printf 'extra\t%s\thooks\n' "$r"
  "${g[@]}" config --local --name-only --list 2>/dev/null |
    grep -Eqv '^(core\.|remote\.|branch\.|submodule\.|lfs\.|extensions\.worktreeconfig)' &&
    printf 'extra\t%s\tlocalconfig\n' "$r"
  "${g[@]}" worktree list --porcelain | awk '/^worktree /{p=substr($0,10)} /^branch /{print p "\t" substr($0,19)} /^detached/{print p "\t(detached)"}' |
  while IFS=$'\t' read -r wt wb; do
    [[ $wt = "$root/$r" || $wt = "$root" && $r = . ]] && continue
    case $wt in "$root"/*) wp=${wt#$root/} ;; "$HOME"/*) wp="~/${wt#$HOME/}" ;; *) wp=$wt ;; esac
    wd=$(git -C "$wt" status --porcelain 2>/dev/null | wc -l | tr -d ' ')
    printf 'worktree\t%s\t%s\t%s\t%s\n' "$r" "$wp" "$wb" "$wd"
  done
done

if command -v docker >/dev/null; then
  docker ps -a --filter label=devcontainer.local_folder \
    --format '{{.Names}}	{{.State}}	{{.Label "devcontainer.local_folder"}}' 2>/dev/null |
  while IFS=$'\t' read -r name state folder; do
    case $folder in "$root"|"$root"/*) printf 'container\t%s\t%s\t%s\n' "$name" "$state" "$(rel "$folder")" ;; esac
  done
fi
