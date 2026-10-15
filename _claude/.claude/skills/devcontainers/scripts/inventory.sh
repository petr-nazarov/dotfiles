#!/usr/bin/env bash
# One line per devcontainer on this host, newest first:
#   name  state  created  home  folder
# home is where the container's /home/vscode lives, which decides whether
# a recreate keeps its logins:
#   folder  bind-backed volume in ../.devcontainer-home/<name>   safe
#   volume  older plain volume under /var/lib/docker              safe, but migrate
#   none    the container's own filesystem                       LOST on recreate
#   gone    the project folder no longer exists                  stale container
set -uo pipefail

docker ps -aq --filter label=devcontainer.local_folder |
while read -r id; do
  docker inspect "$id" --format '{{.Name}}|{{.State.Status}}|{{.Created}}|{{index .Config.Labels "devcontainer.local_folder"}}|{{range .Mounts}}{{if eq .Destination "/home/vscode"}}{{.Name}}{{end}}{{end}}'
done |
while IFS='|' read -r name state created folder volume; do
  if [[ ! -d "$folder" ]]; then
    home=gone
  elif [[ -z "$volume" ]]; then
    home=none
  elif [[ -n "$(docker volume inspect "$volume" --format '{{index .Options "device"}}' 2>/dev/null)" ]]; then
    home=folder
  else
    home=volume
  fi
  printf '%s\t%s\t%s\t%s\t%s\n' "${name#/}" "$state" "${created:0:10}" "$home" "$folder"
done | sort -t$'\t' -k3,3r | column -t -s$'\t'
