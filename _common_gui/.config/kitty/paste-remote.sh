# Run on the ssh host by paste.py, with the image on stdin: saves it where
# the Claude in the active tmux pane can read it and prints that path.
#
# A devcontainer pane runs `docker exec -it <container id>` on the pane's
# terminal; then the image goes into that container's /tmp, as the user the
# exec runs as. Anywhere else it stays on the host.

PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"
name="$(date +%Y%m%d-%H%M%S).png"
container=""
user=""

# The client that was used last is the one this paste comes from
client=$(tmux list-clients -F '#{client_activity} #{client_name}' 2>/dev/null | sort -rn | head -n 1 | cut -d' ' -f2-)
if [ -n "$client" ]; then
  tty=$(tmux display-message -p -c "$client" '#{pane_tty}')
  exec_line=$(ps -t "${tty#/dev/}" -o command= | grep '^docker exec .*-t' | head -n 1)
  container=$(printf '%s\n' "$exec_line" | grep -oE '[0-9a-f]{64}' | head -n 1)
  user=$(printf '%s\n' "$exec_line" | grep -oE ' -u [^ ]+' | head -n 1 | cut -d' ' -f3)
fi

if [ -n "$container" ]; then
  f="/tmp/pasted-images/$name"
  docker exec -i ${user:+-u "$user"} "$container" sh -c 'mkdir -p "${1%/*}" && cat > "$1"' sh "$f" || exit 1
else
  f="$HOME/.cache/pasted-images/$name"
  mkdir -p "${f%/*}" && cat > "$f" || exit 1
fi
printf %s "$f"
