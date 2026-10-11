#!/bin/zsh
# Bring the running devcontainer up to date with the dotfiles without
# recreating it: new dotfiles links, Claude skills and settings, plugins and
# system packages. Starts the container first if it isn't running.
set -e
./.devcontainer/base/host-scripts/base.sh

# Prefer the refresh script from the mounted dotfiles: it is always the newest,
# even when this project's .devcontainer/base copy is old.
devcontainer exec --workspace-folder . zsh -c '
	r="$HOME/dotfiles/.devcontainer/base/scripts/refresh.sh"
	[ -x "$r" ] || r=".devcontainer/base/scripts/refresh.sh"
	"$r"
'
