#!/bin/zsh
# Bring a container up to date with the dotfiles without recreating it.
# Runs on every container start (post-start.sh) and on demand from the host
# (host-scripts/update.sh). Safe to run any number of times: every step only
# adds what is missing or links what is new, and a failing step never stops
# the others.
#
# Callers prefer the copy at ~/dotfiles/.devcontainer/base/scripts/refresh.sh,
# so the newest version runs even in projects whose .devcontainer/base copy is
# old. Template files are therefore read relative to this script, not the
# project.

BASE_DIR="${0:A:h:h}"
DOTFILES_DIR="$HOME/dotfiles"
# claude installs into ~/.local/bin, which a non-interactive zsh may not have.
export PATH="$HOME/.local/bin:$PATH"

echo "🔄 Refreshing container from $BASE_DIR"

# When ~/.claude is bind-mounted from the host (the dotfiles repo's own
# container), it *is* the host's config: the host manages skills and settings
# itself, and writing here would change the host.
CLAUDE_IS_HOST=0
mountpoint -q "$HOME/.claude" 2>/dev/null && CLAUDE_IS_HOST=1

echo "📦 System packages..."
if [ -f "$BASE_DIR/packages.txt" ]; then
	missing=()
	for pkg in ${(f)"$(<"$BASE_DIR/packages.txt")"}; do
		[ -n "$pkg" ] || continue
		dpkg -s "$pkg" >/dev/null 2>&1 || missing+=("$pkg")
	done
	if (( ${#missing} )); then
		echo "  ↳ installing: ${missing[*]}"
		sudo apt-get update -qq && sudo apt-get install -y --no-install-recommends "${missing[@]}"
	fi
fi

echo "🔗 Dotfiles links..."
# --restow also drops links to files that were deleted from the repo.
if [ -d "$DOTFILES_DIR/_headless" ]; then
	(cd "$DOTFILES_DIR" && stow --restow --no-folding -t "$HOME" _headless) ||
		echo "  ⚠️  stow failed, see the conflict above"
fi

echo "🧩 Claude skills..."
SKILLS_SRC="$DOTFILES_DIR/_claude/.claude/skills"
if [ "$CLAUDE_IS_HOST" -eq 1 ]; then
	echo "  ↳ ~/.claude is the host's, skipping"
elif [ -d "$SKILLS_SRC" ]; then
	mkdir -p "$HOME/.claude/skills"
	for src in "$SKILLS_SRC"/*(/N); do
		dest="$HOME/.claude/skills/${src:t}"
		# Leave real directories alone: a skill installed some other way wins.
		if [ -e "$dest" ] && [ ! -L "$dest" ]; then
			echo "  ↳ ${src:t} exists and is not a link, leaving it"
			continue
		fi
		# Relative, so the link resolves wherever ~ is.
		ln -sfn "../../dotfiles/_claude/.claude/skills/${src:t}" "$dest"
	done
	# Skills deleted from the dotfiles leave dangling links behind.
	for link in "$HOME/.claude/skills"/*(@N); do
		[ -e "$link" ] || { echo "  ↳ removing stale ${link:t}"; rm -f "$link"; }
	done
fi

echo "⚙️  Claude settings..."
TEMPLATE="$BASE_DIR/dotfiles/claude-settings.json"
SETTINGS="$HOME/.claude/settings.json"
if [ "$CLAUDE_IS_HOST" -eq 1 ]; then
	echo "  ↳ ~/.claude is the host's, skipping"
elif [ ! -f "$SETTINGS" ]; then
	mkdir -p "$HOME/.claude"
	cp "$TEMPLATE" "$SETTINGS"
else
	# The template's keys win (hooks, statusline, ...); anything else the
	# container added, such as a model choice, is kept.
	merged="$(jq -s '.[0] * .[1]' "$SETTINGS" "$TEMPLATE")" &&
		printf '%s\n' "$merged" > "$SETTINGS" ||
		echo "  ⚠️  could not merge, $SETTINGS left as it was"
fi

echo "📊 ccstatusline..."
if ! command -v ccstatusline >/dev/null 2>&1; then
	if command -v npm >/dev/null 2>&1; then
		npm i -g ccstatusline@latest
	else
		echo "  ⚠️  npm not found, add ghcr.io/devcontainers/features/node to devcontainer.json"
	fi
fi
# Without the ccstatusline mount, seed the layout from the dotfiles.
if [ ! -f "$HOME/.config/ccstatusline/settings.json" ]; then
	CCSL_SRC="$DOTFILES_DIR/_claude/.config/ccstatusline/settings.json"
	if [ -f "$CCSL_SRC" ]; then
		mkdir -p "$HOME/.config/ccstatusline"
		cp "$CCSL_SRC" "$HOME/.config/ccstatusline/settings.json"
	fi
fi

echo "🔌 Claude plugins..."
if command -v claude >/dev/null 2>&1; then
	claude plugin marketplace add anthropics/claude-plugins-official >/dev/null 2>&1
	claude plugin marketplace update claude-plugins-official
	if claude plugin list 2>/dev/null | grep -q 'superpowers@claude-plugins-official'; then
		claude plugin update superpowers@claude-plugins-official
	else
		claude plugin install superpowers@claude-plugins-official
	fi
else
	echo "  ⚠️  claude not installed yet, skipping"
fi

echo "✅ Refresh done"
