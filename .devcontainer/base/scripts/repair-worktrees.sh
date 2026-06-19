#!/bin/bash
set -e

CONTAINER_GIT_ROOT=$(git rev-parse --show-toplevel 2>/dev/null || echo "/workspaces/$(basename "$PWD")")
WORKTREES_META="$CONTAINER_GIT_ROOT/.git/worktrees"
WORKTREES_DIR="$CONTAINER_GIT_ROOT/worktrees"

echo "Git root: $CONTAINER_GIT_ROOT"

[ -d "$WORKTREES_META" ] || { echo "No worktree metadata, skipping"; exit 0; }

for meta_dir in "$WORKTREES_META"/*/; do
  [ -d "$meta_dir" ] || continue
  wt_name=$(basename "$meta_dir")
  container_wt_path="$WORKTREES_DIR/$wt_name"
  gitdir_file="$meta_dir/gitdir"

  echo "  worktree: $wt_name"

  # Rewrite the stored path to container path
  echo "$container_wt_path/.git" > "$gitdir_file"

  # Also fix the .git file inside the worktree if it exists
  if [ -f "$container_wt_path/.git" ]; then
    echo "gitdir: $WORKTREES_META/$wt_name" > "$container_wt_path/.git"
  fi

  git worktree repair "$container_wt_path" 2>/dev/null && echo "    repaired" || echo "    skipped (dir not found)"
done

echo "Done."
git worktree list
