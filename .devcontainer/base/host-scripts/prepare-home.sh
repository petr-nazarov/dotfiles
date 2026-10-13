#!/bin/zsh
# Create the folder that holds the container's home before devcontainer.json
# mounts it (initializeCommand runs this). See "Persistent home" in the README.
#
# The folder sits next to the project, not inside it: the image build context
# is the whole project, and tools in the container scan the workspace. It must
# be on the same filesystem as the project, so a project in an encrypted folder
# keeps the container's logins encrypted too.
set -e
zmodload -F zsh/stat b:zstat

project="${1:A}"
home_dir="${project:h}/.devcontainer-home/${project:t}"

# Checked on the parent, before anything is created there.
if [[ "$(zstat +device "$project")" != "$(zstat +device "${project:h}")" ]]; then
	echo "$home_dir would not be on the same filesystem as $project," >&2
	echo "so the container's logins would be stored outside the project's folder." >&2
	echo "Move the project one folder deeper." >&2
	exit 1
fi

mkdir -p -m 700 "${home_dir:h}" "$home_dir"
