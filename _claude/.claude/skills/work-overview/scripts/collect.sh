#!/usr/bin/env bash
# Gather everything the user did for one client in a time window.
#   bash collect.sh <since> <until> <client root>
# <since> and <until> are local times, YYYY-MM-DD or YYYY-MM-DDTHH:MM; <since>
# is included, <until> is not. Runs on macOS bash 3.2 and in the devcontainers
# (bash, git, jq, gh), so no mapfile, associative arrays or GNU-only flags.
#
# Output, in sections:
#   == repo <path> (<owner/repo or "no github remote">)
#      <date> <ref> <subject>          the user's commits on any branch
#      pr #<n> <state> <title>         the user's PRs updated in the window
#      issue #<n> <state> <title>      issues involving the user updated in the window
#      wip <branch> <n> files changed  uncommitted work right now
#   == claude <session title> (<first cwd>)
#      <local time> <prompt, first 300 chars>
set -uo pipefail

since=$1 until=$2 root=${3%/}
[[ -d $root ]] || { echo "error: no such folder: $root"; exit 1; }
sdate=${since%%T*} udate=${until%%T*}
# a bare date means midnight; git would otherwise take the current time of day
[[ $since == *T* ]] || since+=T00:00
[[ $until == *T* ]] || until+=T00:00

in_container=no
if [[ -f /.dockerenv || -n ${REMOTE_CONTAINERS:-} || $root == /workspaces* ]]; then in_container=yes; fi
echo "window $since .. $until (local), root $root, container $in_container"

# --- git and GitHub -------------------------------------------------------
# gh can hold several accounts (one per client). Every logged-in login counts as
# the user: merges and edits made on github.com are authored as the login, not
# the local git name. Each repo is read with the first account that can see it.
logins=
if command -v gh >/dev/null; then
	logins=$(gh auth status -h github.com --json hosts --jq '.hosts["github.com"][]? | select(.state == "success") | .login' 2>/dev/null)
fi
[[ -z $logins ]] && echo "note: gh not logged in, no PR or issue data"

seen=" "
find "$root" -maxdepth 4 \( -name node_modules -o -name .devcontainer-home \) -prune -o -name .git -print 2>/dev/null | sort |
while read -r dotgit; do
	repo=$(dirname "$dotgit")
	# a worktree made inside a devcontainer points at /workspaces/... and can't be read here;
	# its commits still show up through the main repo
	common=$(cd "$repo" 2>/dev/null && cd "$(git rev-parse --git-common-dir 2>/dev/null)" 2>/dev/null && pwd) || continue
	case $seen in *" $common "*) continue ;; esac
	seen="$seen$common "

	# origin may use an ssh alias (git@client-github:owner/repo.git), so resolve the host
	url=$(git -C "$repo" remote get-url origin 2>/dev/null)
	host=$(printf '%s' "$url" | sed -nE 's#^(ssh://)?([^@/]+@)?([^:/]+)[:/].*#\3#p')
	[[ $host != github.com ]] && host=$(ssh -G "$host" 2>/dev/null | awk '$1 == "hostname" {print $2}')
	slug=
	[[ $host == github.com ]] && slug=$(printf '%s' "$url" | sed -nE 's#.*[:/]([^/:]+/[^/]+)$#\1#p' | sed 's/\.git$//')

	authors=()
	for a in "$(git -C "$repo" config user.email)" "$(git -C "$repo" config user.name)" $logins; do
		[[ -n $a ]] && authors+=(--author="$a")
	done
	[[ ${#authors[@]} == 0 ]] && authors=(--author="^$")
	out=$(git -C "$repo" log --all --no-merges --source --since="$since" --until="$until" \
		"${authors[@]}" --date=format:'%Y-%m-%d' --format='   %ad %S %s' 2>/dev/null |
		sed 's# refs/heads/# #; s# refs/remotes/# #' | sort -u)

	ghnote=
	if [[ -n $logins && -n $slug ]]; then
		token=
		for l in $logins; do
			t=$(gh auth token -h github.com -u "$l" 2>/dev/null)
			if GH_TOKEN=$t gh api "repos/$slug" --silent 2>/dev/null; then token=$t login=$l; break; fi
		done
		if [[ -n $token ]]; then
			out+=$'\n'$(GH_TOKEN=$token gh pr list -R "$slug" --author "$login" --state all --limit 50 --search "updated:$sdate..$udate" \
				--json number,state,title -q '.[] | "   pr #\(.number) \(.state) \(.title)"' 2>/dev/null)
			out+=$'\n'$(GH_TOKEN=$token gh issue list -R "$slug" --state all --limit 50 --search "involves:$login updated:$sdate..$udate" \
				--json number,state,title -q '.[] | "   issue #\(.number) \(.state) \(.title)"' 2>/dev/null)
		else
			ghnote="   note: no gh account here can read $slug, so no PRs or issues (the client's devcontainer may have one)"
		fi
	fi
	# repos with nothing in the window are left out, uncommitted changes included
	[[ -z ${out//[$'\n ']/} ]] && continue

	echo
	echo "== repo $repo (${slug:-no github remote})"
	printf '%s\n' "$out" | grep -v '^$'
	[[ -n $ghnote ]] && echo "$ghnote"
	dirty=$(git -C "$repo" status --porcelain 2>/dev/null | grep -v -c '\.DS_Store$')
	[[ $dirty != 0 ]] && echo "   wip $(git -C "$repo" branch --show-current) $dirty files changed"
done

# --- Claude history -------------------------------------------------------
# Claude stores each project's sessions in ~/.claude/projects/<path with every
# non-alphanumeric character turned into ->/<session>.jsonl.
dirs=()
if [[ $in_container == yes ]]; then
	[[ -d $HOME/.claude/projects ]] && dirs+=("$HOME/.claude/projects")
else
	enc=$(printf '%s' "$root" | sed 's/[^A-Za-z0-9]/-/g')
	for d in "$HOME"/.claude/projects/*; do
		b=$(basename "$d")
		[[ $b == "$enc" || $b == "$enc"-* ]] && dirs+=("$d")
	done
	# devcontainer homes: <workspace>/../.devcontainer-home/<workspace name>/.claude
	for d in "$root"/.devcontainer-home/*/.claude/projects "$root"/*/.devcontainer-home/*/.claude/projects \
		"$(dirname "$root")/.devcontainer-home/$(basename "$root")/.claude/projects"; do
		[[ -d $d ]] && dirs+=("$d")
	done
fi
[[ ${#dirs[@]} == 0 ]] && { echo; echo "note: no Claude history found for $root"; exit 0; }

find "${dirs[@]}" -maxdepth 2 -name '*.jsonl' -newermt "$since" 2>/dev/null | sort |
while read -r f; do
	lines=$(jq -r --arg s "$since" --arg u "$until" '
		def local: sub("\\.[0-9]+Z$"; "Z") | fromdateiso8601 | localtime | strftime("%Y-%m-%dT%H:%M");
		select(.type == "user" and (.isMeta | not) and .timestamp != null)
		| (.message.content | if type == "string" then . else ([.[]? | select(.type == "text") | .text] | join(" ")) end) as $t
		| select($t | test("^\\s*(<command-|<local-command|<system-reminder|<task-notification|This session is being continued|\\[Request interrupted|Caveat:)") | not)
		| select($t | test("\\S"))
		| (.timestamp | local) as $ts
		| select($ts >= $s and $ts < $u)
		# keys, tokens and passwords pasted into prompts never reach the output
		| ($t | gsub("</?pasted_content[^>]*>"; "")
			| gsub("(?<k>://[^:/@\\s]+:)[^@\\s]+@"; "\(.k)[secret]@")
			| gsub("(?i)(?<k>(password|passwd|secret|token|key)\\S*\\s*[:=]\\s*)\\S+"; "\(.k)[secret]")
			| gsub("\\b(sk|pk|rk|ghp|gho|ghs|github_pat|xox[abp]|sbp|AKIA)[-_A-Za-z0-9]{12,}"; "[secret]")
			| gsub("\\beyJ[-_A-Za-z0-9.]{20,}"; "[secret]")
			| gsub("(?<![/#])\\b(?=[A-Za-z_+-]*[0-9])(?=[0-9_+-]*[A-Za-z])[A-Za-z0-9_+-]{32,}"; "[secret]")
			| gsub("\\s+"; " ") | .[0:300]) as $clean
		| "   \($ts) \($clean)\t\(.cwd)"
	' "$f" 2>/dev/null)
	[[ -z $lines ]] && continue
	title=$(jq -r 'select(.type == "custom-title" or .type == "ai-title") | .customTitle // .aiTitle' "$f" 2>/dev/null | tail -1)
	echo
	echo "== claude ${title:-untitled} ($(printf '%s\n' "$lines" | head -1 | cut -f2))"
	printf '%s\n' "$lines" | cut -f1
done
