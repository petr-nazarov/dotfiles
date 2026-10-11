#!/bin/zsh
# One-time move of an existing container onto the persistent home volume.
#
# Containers created before devcontainer.json had the
# "devcontainer-home-${devcontainerId}" mount keep their logins only in the
# container's own filesystem, so a plain --recreate would lose them. This
# copies /home/vscode out of the old container, recreates it with the volume,
# and copies the files back in. Bind-mounted paths (dotfiles, ssh config, ...)
# are skipped: they live on the host already.
set -e

if ! grep -qF 'devcontainer-home-${devcontainerId}' .devcontainer/devcontainer.json; then
	echo "Add the home volume mount from .devcontainer/base/devcontainer.json to" >&2
	echo ".devcontainer/devcontainer.json first, then run this again." >&2
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

if docker inspect "$OLD" --format '{{range .Mounts}}{{if eq .Destination "/home/vscode"}}yes{{end}}{{end}}' | grep -q yes; then
	echo "Container $OLD already has its home on a volume, nothing to do."
	exit 0
fi

# The copy holds credentials: keep it private and delete it however we exit.
WORK="$(mktemp -d "${XDG_CACHE_HOME:-$HOME/.cache}/devcontainer-migrate.XXXXXX")"
chmod 700 "$WORK"
trap 'rm -rf "$WORK"' EXIT

excludes=()
for dest in ${(f)"$(docker inspect "$OLD" --format '{{range .Mounts}}{{.Destination}}{{"\n"}}{{end}}')"}; do
	[[ "$dest" == /home/vscode/* ]] && excludes+=("--exclude=./${dest#/home/vscode/}")
done

echo "📤 Copying /home/vscode out of $OLD..."
docker start "$OLD" >/dev/null
docker exec -u root "$OLD" tar -C /home/vscode "${excludes[@]}" -cf - . > "$WORK/home.tar"
echo "  ↳ $(du -h "$WORK/home.tar" | cut -f1)"

echo "♻️  Recreating with the home volume..."
./.devcontainer/base/host-scripts/base.sh --recreate

NEW="$(docker ps -q --filter "label=devcontainer.local_folder=$PWD")"
echo "📥 Copying files into $NEW..."
docker exec -i -u root "$NEW" tar -C /home/vscode -xpf - < "$WORK/home.tar"

echo "🔄 Refreshing..."
./.devcontainer/base/host-scripts/update.sh

echo "✅ Migrated. Logins in this container now survive --recreate."
