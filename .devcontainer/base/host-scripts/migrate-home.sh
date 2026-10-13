#!/bin/zsh
# One-time move of an existing container's home into the project's home folder
# (see "Persistent home" in the README), then recreate the container on it.
#
# Handles containers whose home is still in their own filesystem and ones on
# the older plain Docker volume, which lives unencrypted under /var/lib/docker
# and is deleted once the move has worked. The files go straight from the
# container into the home folder, never through a temp copy. Bind-mounted paths
# (dotfiles, ssh config, ...) are skipped: they live on the host already.
set -e
setopt pipefail

if ! grep -qF '.devcontainer-home/${localWorkspaceFolderBasename}' .devcontainer/devcontainer.json; then
	echo "Copy the home mount and initializeCommand from .devcontainer/base/devcontainer.json" >&2
	echo "into .devcontainer/devcontainer.json first, then run this again." >&2
	exit 1
fi

ids=(${(f)"$(docker ps -aq --filter "label=devcontainer.local_folder=$PWD")"})
if (( ${#ids} == 0 )); then
	echo "No existing container for $PWD, nothing to migrate. Start it with shell.sh." >&2
	exit 1
elif (( ${#ids} > 1 )); then
	echo "More than one container for $PWD (${ids[*]}). Remove the ones you don't need first." >&2
	exit 1
fi
OLD="${ids[1]}"

HOME_DIR="${PWD:A:h}/.devcontainer-home/${PWD:A:t}"
old_volume="$(docker inspect "$OLD" --format '{{range .Mounts}}{{if eq .Destination "/home/vscode"}}{{.Name}}{{end}}{{end}}')"
if [[ -n "$old_volume" ]]; then
	device="$(docker volume inspect "$old_volume" --format '{{index .Options "device"}}')"
	if [[ -n "$device" && "${device:A}" == "$HOME_DIR" ]]; then
		echo "Container $OLD already has its home in $HOME_DIR, nothing to do."
		exit 0
	fi
fi

if [[ -d "$HOME_DIR" && -n "$(ls -A "$HOME_DIR")" ]]; then
	echo "$HOME_DIR already holds files. Move them away first." >&2
	exit 1
fi
.devcontainer/base/host-scripts/prepare-home.sh "$PWD"

excludes=()
for dest in ${(f)"$(docker inspect "$OLD" --format '{{range .Mounts}}{{.Destination}}{{"\n"}}{{end}}')"}; do
	[[ "$dest" == /home/vscode/* ]] && excludes+=("--exclude=./${dest#/home/vscode/}")
done

echo "📤 Copying /home/vscode out of $OLD into $HOME_DIR..."
docker start "$OLD" >/dev/null
docker exec -u root "$OLD" tar -C /home/vscode "${excludes[@]}" -cf - . | tar -C "$HOME_DIR" -xpf -
echo "  ↳ $(du -sh "$HOME_DIR" | cut -f1)"

echo "♻️  Recreating with the home folder..."
./.devcontainer/base/host-scripts/base.sh --recreate

if [[ -n "$old_volume" ]]; then
	echo "🗑️  Deleting the old home volume $old_volume..."
	docker volume rm "$old_volume" >/dev/null
fi

echo "🔄 Refreshing..."
./.devcontainer/base/host-scripts/update.sh

echo "✅ Migrated. The home now lives in $HOME_DIR."
