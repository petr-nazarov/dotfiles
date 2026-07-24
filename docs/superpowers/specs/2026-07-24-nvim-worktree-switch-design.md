# nvim git-worktree switcher

## Problem

The dotfiles already have a shell-level git-worktree workflow (`git-worktree-create`,
`git-worktree-select`, and the `gwc`/`gws`/`gwd` aliases in
`_headless/.config/zsh/aliases.zsh`) that lets you create, `cd` into, and delete
worktrees living under `worktrees/<name>` at the repo root. There is no equivalent
inside nvim: switching worktrees means leaving nvim (or opening a shell split) to
`cd` and relaunching. This spec adds an in-nvim equivalent: a keybinding that opens
an fzf-lua picker of worktrees and switches nvim's cwd to the selected one, plus a
statusline indicator so you always know which worktree the current nvim session is
rooted in.

## Non-goals

- No worktree creation or deletion from nvim (`gwc`/`gwd` stay shell-only).
- No per-tab worktree scoping (see "Switch scope" decision below) — the switch
  affects the whole nvim session.
- No LSP client restart/reattachment logic — closing all buffers before the `cd`
  is expected to naturally tear down buffer-attached LSP clients; no special
  handling is added for stale clients.

## Design

### New module: `_headless/.config/nvim/lua/git_worktree.lua`

A plain Lua module (not a lazy.nvim plugin spec) with three functions. It has no
`require` at file scope beyond `vim.*` — `fzf-lua` is required lazily inside
`select()` so this module stays cheap to load from non-lazy files.

#### `M.current_name()`

Returns the display name of the worktree the current nvim session's cwd
(`vim.fn.getcwd()`) is inside, or `nil` if the cwd is the main worktree.

- Pattern-match the cwd for `/worktrees/([^/]+)` (mirrors the `worktrees/$NAME`
  layout `git-worktree-create` produces).
- Match found → return `<name>`.
- No match → return `nil` (the main worktree has no path segment to match).

This is a pure string match, no subprocess, so it's cheap enough to call on every
lualine refresh (1000ms, per `lualine.lua`'s `refresh.statusline`).

#### `M.list()`

Returns an array of `{ display, path }` entries describing every worktree of the
current repo.

- Resolve the repo root via `git rev-parse --show-toplevel` (`vim.fn.system`),
  trimmed.
- Run `git worktree list --porcelain` from that root (`vim.fn.systemlist`) and
  parse it into blocks separated by blank lines. Each block has a `worktree
  <path>` line and either a `branch refs/heads/<name>` line or a `detached` line.
- For each block, rebuild the path relative to the *current* repo root rather
  than trusting the absolute path git recorded: if the recorded path contains
  `/worktrees/`, rebuild as `<repo_root>/worktrees/<suffix after /worktrees/>`;
  otherwise it's the main worktree, use `repo_root` itself. This mirrors the
  rebuilding logic already in `git-worktree-select` and keeps things correct when
  the repo is mounted at a different absolute path (e.g. a devcontainer).
- `display` is the worktree's name: `main` for the main worktree, or the
  `<name>` segment after `/worktrees/` for the rest. Include the branch name
  from the `branch` line in the display string for readability, e.g.
  `test1  (test1)` — for the main worktree, still show `main  (<branch>)`.

#### `M.select()`

The action bound to `<leader>gws`.

1. Call `M.list()`. If it returns zero or one entry, `vim.notify("No other
   worktrees", vim.log.levels.INFO)` and return early (nothing to switch to).
2. Call `require("fzf-lua").fzf_exec(entries_display, { prompt = "Worktree> ",
   actions = { ["default"] = function(selected) ... end } })`, where the action
   callback maps the selected display string back to its `path`.
3. Inside the action callback:
   - Check every listed buffer (`vim.api.nvim_list_bufs()`) for
     `vim.bo[buf].modified`. If any is modified, `vim.notify("Unsaved changes in
     <bufname> — save or discard before switching worktrees",
     vim.log.levels.WARN)` and **abort** — do not close buffers or change cwd.
   - Otherwise, delete every buffer (iterate `vim.api.nvim_list_bufs()` and
     `vim.api.nvim_buf_delete(buf, { force = false })` — `force = false` is
     intentional/defensive here since the modified-check above should have
     already ruled out unsaved changes; if delete unexpectedly fails on some
     buffer, let the error surface rather than silently discarding data).
   - Change nvim's global working directory: `vim.cmd.cd(path)`.
   - `vim.notify("Switched to worktree: <display>")` for feedback.

### Keybinding — `_headless/.config/nvim/lua/keybindings.lua`

Add to the existing `which-key` registration, under the current `<leader>g` Git
group (alongside `gd`, `gi`, `gb`, `gn`, `gp`, `gs`):

```lua
{ "<leader>gw",  group = "Worktree" },
{ "<leader>gws", function() require("git_worktree").select() end, desc = "Switch worktree" },
```

### Statusline — `_headless/.config/nvim/lua/plugins/lualine.lua`

Add a function component to `lualine_b`, immediately after `'branch'`:

```lua
lualine_b = {
  'branch',
  function() return require("git_worktree").current_name() or "" end,
  'diff',
  'diagnostics'
},
```

Returning `""` on the main worktree means lualine renders nothing there (no
empty bracket/separator clutter); returning the name (e.g. `test1`) on a
worktree shows it right next to the branch name.

## Testing

Manual verification (no automated test harness exists for this nvim config):

1. From the main worktree, open nvim, confirm no worktree name shows in the
   statusline.
2. Run `<leader>gws`, confirm the fzf-lua picker lists all worktrees (including
   `worktrees/test1`, already present in this repo) with readable
   name/branch labels.
3. Select `test1`, confirm: buffers close, `:pwd` reports the `worktrees/test1`
   path, and the statusline now shows `test1`.
4. Switch back to `main` via the picker, confirm the statusline indicator
   disappears again.
5. Open a file, make an unsaved edit, run `<leader>gws` and pick another
   worktree — confirm nvim warns and does **not** switch (buffers stay open,
   cwd unchanged).
6. Save or discard the edit, retry the same switch — confirm it now succeeds.
