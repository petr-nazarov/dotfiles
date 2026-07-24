# nvim git-worktree switcher Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add an in-nvim `<leader>gws` fzf-lua picker that switches nvim's cwd between git worktrees (mirroring the existing shell `gws` alias), plus a lualine statusline indicator showing which worktree the session is in.

**Architecture:** A single new Lua module, `git_worktree.lua`, exposes four functions (`current_name`, `list`, `switch_to`, `select`). `keybindings.lua` binds `<leader>gws` to `select()`; `lualine.lua` adds a component calling `current_name()`. `select()` is the only function that touches `fzf-lua`, required lazily inside it so the module has zero load-time dependencies.

**Tech Stack:** Neovim Lua (`vim.fn`, `vim.api`), `fzf-lua` (already a dependency, see `_headless/.config/nvim/lua/plugins/fzf-lua.lua`), `which-key.nvim` (already a dependency, see `_headless/.config/nvim/lua/keybindings.lua`), `lualine.nvim` (already configured in `_headless/.config/nvim/lua/plugins/lualine.lua`). No new plugins.

## Global Constraints

- Worktree layout convention (from `_headless/.local/bin/git-worktree-create`): every non-main worktree lives at `<repo_root>/worktrees/<name>`. All name/path detection logic must key off this exact layout.
- `current_name()` must not shell out — it runs on every lualine refresh (1000ms, per `lualine.lua`'s `options.refresh.statusline`) and must stay a cheap string match.
- `git_worktree.lua` must not `require("fzf-lua")` at file scope — only inside `select()` — so requiring the module from non-lazy files (`keybindings.lua`) never forces `fzf-lua` to load early.
- No worktree creation/deletion from nvim — `gwc`/`gwd` stay shell-only (non-goal, spec section "Non-goals").
- No per-tab worktree scoping — the switch is global (`vim.cmd.cd`, not `vim.cmd.tcd`), affecting the whole nvim session (non-goal, spec section "Non-goals").
- If any buffer is modified when `<leader>gws` is invoked, abort the switch entirely (no buffer closes, no cwd change) and `vim.notify(..., vim.log.levels.WARN)`.

---

## Task 1: `git_worktree.lua` — `current_name()`

**Files:**
- Create: `_headless/.config/nvim/lua/git_worktree.lua`

**Interfaces:**
- Produces: `M.current_name()` — no args, returns `string|nil`: the worktree name if `vim.fn.getcwd()` contains a `/worktrees/<name>` segment, else `nil`.

- [ ] **Step 1: Write the failing test**

Create `/tmp/claude-1000/-home-nazarov-dotfiles/784fe375-c762-4c7d-a07d-7849e2aaa99c/scratchpad/test_current_name.lua`:

```lua
package.path = package.path .. ";_headless/.config/nvim/lua/?.lua"

local ok, err = pcall(function()
  local M = require("git_worktree")

  -- in a worktree subdirectory
  local target = os.getenv("TEST_WT_PATH")
  vim.cmd.cd(target)
  local name = M.current_name()
  assert(name == "feature", "expected 'feature', got " .. tostring(name))

  -- in the main worktree (no /worktrees/ segment)
  local root = os.getenv("TEST_ROOT_PATH")
  vim.cmd.cd(root)
  local main_name = M.current_name()
  assert(main_name == nil, "expected nil in main worktree, got " .. tostring(main_name))
end)

if ok then
  print("PASS: current_name")
  os.exit(0)
else
  print("FAIL: current_name: " .. tostring(err))
  os.exit(1)
end
```

- [ ] **Step 2: Set up a scratch git repo with a real worktree, and run the test to verify it fails**

```bash
SCRATCH=/tmp/claude-1000/-home-nazarov-dotfiles/784fe375-c762-4c7d-a07d-7849e2aaa99c/scratchpad/wt-fixture
rm -rf "$SCRATCH"
mkdir -p "$SCRATCH"
git init -q "$SCRATCH/repo"
git -C "$SCRATCH/repo" config user.email "test@test.com"
git -C "$SCRATCH/repo" config user.name "test"
echo hi > "$SCRATCH/repo/f.txt"
git -C "$SCRATCH/repo" add f.txt
git -C "$SCRATCH/repo" commit -qm init
git -C "$SCRATCH/repo" worktree add worktrees/feature -b feature --quiet

cd /home/nazarov/dotfiles
TEST_WT_PATH="$SCRATCH/repo/worktrees/feature" \
TEST_ROOT_PATH="$SCRATCH/repo" \
nvim --headless --clean \
  -c "lua dofile('/tmp/claude-1000/-home-nazarov-dotfiles/784fe375-c762-4c7d-a07d-7849e2aaa99c/scratchpad/test_current_name.lua')"
```

Expected: `FAIL: current_name: ...module 'git_worktree' not found...` and a non-zero exit code (check with `echo $?` immediately after).

- [ ] **Step 3: Write the minimal implementation**

```lua
local M = {}

function M.current_name()
  local cwd = vim.fn.getcwd()
  return cwd:match("/worktrees/([^/]+)")
end

return M
```

- [ ] **Step 4: Run the test to verify it passes**

Run the same `nvim --headless` command from Step 2.
Expected: prints `PASS: current_name`, exit code `0`.

- [ ] **Step 5: Commit**

```bash
git add _headless/.config/nvim/lua/git_worktree.lua
git commit -m "feat: add current_name() worktree detector for nvim"
```

---

## Task 2: `git_worktree.lua` — `list()`

**Files:**
- Modify: `_headless/.config/nvim/lua/git_worktree.lua`

**Interfaces:**
- Consumes: nothing from Task 1 (adds a sibling function in the same module).
- Produces: `M.list()` — no args, returns `{ { display = string, path = string }, ... }`, one entry per worktree of the current repo (main worktree included, `display` starting with `"main"`).

- [ ] **Step 1: Write the failing test**

Create `/tmp/claude-1000/-home-nazarov-dotfiles/784fe375-c762-4c7d-a07d-7849e2aaa99c/scratchpad/test_list.lua`:

```lua
package.path = package.path .. ";_headless/.config/nvim/lua/?.lua"

local ok, err = pcall(function()
  local M = require("git_worktree")
  local entries = M.list()
  assert(#entries == 2, "expected 2 worktrees, got " .. #entries)

  local main_entry, feature_entry
  for _, e in ipairs(entries) do
    if e.display:match("^main") then main_entry = e end
    if e.display:match("^feature") then feature_entry = e end
  end

  assert(main_entry, "expected an entry whose display starts with 'main'")
  assert(main_entry.path == vim.fn.getcwd(), "main path should equal repo root, got " .. main_entry.path)

  assert(feature_entry, "expected an entry whose display starts with 'feature'")
  assert(feature_entry.path == vim.fn.getcwd() .. "/worktrees/feature",
    "feature path should be rebuilt under worktrees/feature, got " .. feature_entry.path)
  assert(feature_entry.display:match("%(feature%)"), "feature entry should show its branch name, got " .. feature_entry.display)
end)

if ok then
  print("PASS: list")
  os.exit(0)
else
  print("FAIL: list: " .. tostring(err))
  os.exit(1)
end
```

- [ ] **Step 2: Run it to verify it fails**

```bash
cd /tmp/claude-1000/-home-nazarov-dotfiles/784fe375-c762-4c7d-a07d-7849e2aaa99c/scratchpad/wt-fixture/repo
nvim --headless --clean \
  -c "lua package.path = package.path .. ';/home/nazarov/dotfiles/_headless/.config/nvim/lua/?.lua'" \
  -c "lua dofile('/tmp/claude-1000/-home-nazarov-dotfiles/784fe375-c762-4c7d-a07d-7849e2aaa99c/scratchpad/test_list.lua')"
```

Note: this test must run with the scratch repo root as nvim's cwd (unlike Task 1's test, `list()` doesn't take a path argument — it always operates on the current repo). Since we're now running from inside the fixture repo rather than the dotfiles repo, add the dotfiles `lua/` dir to `package.path` explicitly via an extra `-c` (shown above) instead of relying on a relative path.

Expected: `FAIL: list: ...attempt to call field 'list' (a nil value)...`, non-zero exit.

- [ ] **Step 3: Write the minimal implementation**

Append to `_headless/.config/nvim/lua/git_worktree.lua` (before `return M`):

```lua
function M.list()
  local root = vim.trim(vim.fn.system("git rev-parse --show-toplevel"))
  if vim.v.shell_error ~= 0 then
    return {}
  end

  local lines = vim.fn.systemlist(
    "git -C " .. vim.fn.shellescape(root) .. " worktree list --porcelain"
  )

  local entries = {}
  local cur_path, cur_branch

  local function flush()
    if not cur_path then
      return
    end
    local name = cur_path:match("/worktrees/([^/]+)$")
    local display_name = name or "main"
    local path = name and (root .. "/worktrees/" .. name) or root
    local branch = cur_branch or "detached"
    table.insert(entries, { display = display_name .. "  (" .. branch .. ")", path = path })
    cur_path, cur_branch = nil, nil
  end

  for _, line in ipairs(lines) do
    if line == "" then
      flush()
    elseif line:match("^worktree ") then
      cur_path = line:match("^worktree (.+)$")
    elseif line:match("^branch refs/heads/") then
      cur_branch = line:match("^branch refs/heads/(.+)$")
    elseif line == "detached" then
      cur_branch = "detached"
    end
  end
  flush()

  return entries
end
```

- [ ] **Step 4: Run the test to verify it passes**

Run the same command from Step 2.
Expected: prints `PASS: list`, exit code `0`.

- [ ] **Step 5: Commit**

```bash
cd /home/nazarov/dotfiles
git add _headless/.config/nvim/lua/git_worktree.lua
git commit -m "feat: add list() worktree enumerator for nvim"
```

---

## Task 3: `git_worktree.lua` — `switch_to()`

**Files:**
- Modify: `_headless/.config/nvim/lua/git_worktree.lua`

**Interfaces:**
- Consumes: an entry shaped like `M.list()`'s elements: `{ display = string, path = string }`.
- Produces: `M.switch_to(entry)` — returns `true` if the switch happened, `false` if aborted (modified buffer present). On success: every listed buffer is deleted, nvim's global cwd becomes `entry.path`, and a confirmation `vim.notify` fires. On abort: nothing changes, a warning `vim.notify` fires naming the modified buffer.

- [ ] **Step 1: Write the failing test**

Create `/tmp/claude-1000/-home-nazarov-dotfiles/784fe375-c762-4c7d-a07d-7849e2aaa99c/scratchpad/test_switch_to.lua`:

```lua
package.path = package.path .. ";_headless/.config/nvim/lua/?.lua"

local ok, err = pcall(function()
  local M = require("git_worktree")
  local target = os.getenv("TEST_WT_PATH")
  local before_cwd = vim.fn.getcwd()

  -- an unsaved, modified buffer must block the switch
  vim.cmd("enew")
  vim.api.nvim_buf_set_lines(0, 0, -1, false, { "dirty" })
  vim.bo.modified = true

  local aborted = M.switch_to({ display = "feature  (feature)", path = target })
  assert(aborted == false, "expected switch_to to return false when a buffer is modified")
  assert(vim.fn.getcwd() == before_cwd, "cwd must not change when the switch is aborted")

  -- clear the modified flag, then the real switch must succeed
  vim.bo.modified = false
  local switched = M.switch_to({ display = "feature  (feature)", path = target })
  assert(switched == true, "expected switch_to to return true on a clean switch")
  assert(vim.fn.getcwd() == target, "cwd should now be " .. target .. ", got " .. vim.fn.getcwd())

  local listed = vim.tbl_filter(function(b) return vim.fn.buflisted(b) == 1 end, vim.api.nvim_list_bufs())
  assert(#listed == 1, "expected exactly one buffer left after switching, got " .. #listed)
end)

if ok then
  print("PASS: switch_to")
  os.exit(0)
else
  print("FAIL: switch_to: " .. tostring(err))
  os.exit(1)
end
```

- [ ] **Step 2: Run it to verify it fails**

```bash
cd /home/nazarov/dotfiles
TEST_WT_PATH=/tmp/claude-1000/-home-nazarov-dotfiles/784fe375-c762-4c7d-a07d-7849e2aaa99c/scratchpad/wt-fixture/repo/worktrees/feature \
nvim --headless --clean \
  -c "lua dofile('/tmp/claude-1000/-home-nazarov-dotfiles/784fe375-c762-4c7d-a07d-7849e2aaa99c/scratchpad/test_switch_to.lua')"
```

Expected: `FAIL: switch_to: ...attempt to call field 'switch_to' (a nil value)...`, non-zero exit.

- [ ] **Step 3: Write the minimal implementation**

Append to `_headless/.config/nvim/lua/git_worktree.lua` (before `return M`):

```lua
function M.switch_to(entry)
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.bo[buf].modified then
      vim.notify(
        "Unsaved changes in " .. vim.api.nvim_buf_get_name(buf) .. " -- save or discard before switching worktrees",
        vim.log.levels.WARN
      )
      return false
    end
  end

  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.fn.buflisted(buf) == 1 then
      vim.api.nvim_buf_delete(buf, { force = false })
    end
  end

  vim.cmd.cd(entry.path)
  vim.notify("Switched to worktree: " .. entry.display)
  return true
end
```

- [ ] **Step 4: Run the test to verify it passes**

Run the same command from Step 2.
Expected: prints `PASS: switch_to`, exit code `0`.

- [ ] **Step 5: Commit**

```bash
git add _headless/.config/nvim/lua/git_worktree.lua
git commit -m "feat: add switch_to() with unsaved-changes guard for nvim"
```

- [ ] **Step 6: Clean up the scratch fixture**

```bash
rm -rf /tmp/claude-1000/-home-nazarov-dotfiles/784fe375-c762-4c7d-a07d-7849e2aaa99c/scratchpad/wt-fixture
```

---

## Task 4: `git_worktree.lua` — `select()` (fzf-lua wiring)

**Files:**
- Modify: `_headless/.config/nvim/lua/git_worktree.lua`

**Interfaces:**
- Consumes: `M.list()` (Task 2) and `M.switch_to(entry)` (Task 3).
- Produces: `M.select()` — no args, no return value. The function bound to `<leader>gws`.

This function drives an interactive `fzf-lua` picker, so it cannot be exercised headlessly the way Tasks 1-3 were (there's no terminal UI in `--headless` mode). It's covered by the manual end-to-end verification in Task 6 instead. Implement it directly:

- [ ] **Step 1: Write the implementation**

Append to `_headless/.config/nvim/lua/git_worktree.lua` (before `return M`):

```lua
function M.select()
  local entries = M.list()
  if #entries <= 1 then
    vim.notify("No other worktrees", vim.log.levels.INFO)
    return
  end

  local by_display = {}
  local display_list = {}
  for _, e in ipairs(entries) do
    by_display[e.display] = e
    table.insert(display_list, e.display)
  end

  require("fzf-lua").fzf_exec(display_list, {
    prompt = "Worktree> ",
    actions = {
      ["default"] = function(selected)
        local entry = by_display[selected[1]]
        if entry then
          M.switch_to(entry)
        end
      end,
    },
  })
end
```

- [ ] **Step 2: Verify the module loads without syntax errors**

```bash
nvim --headless --clean \
  -c "lua package.path = package.path .. ';_headless/.config/nvim/lua/?.lua'" \
  -c "lua local M = require('git_worktree'); assert(type(M.select) == 'function'); print('PASS: module loads, select is a function')" \
  -c "qa!"
```

Expected: prints `PASS: module loads, select is a function`, no Lua errors printed.

- [ ] **Step 3: Commit**

```bash
git add _headless/.config/nvim/lua/git_worktree.lua
git commit -m "feat: add select() fzf-lua worktree picker for nvim"
```

---

## Task 5: Wire the keybinding and lualine component

**Files:**
- Modify: `_headless/.config/nvim/lua/keybindings.lua:99` (insert after the existing `<leader>gs` entry)
- Modify: `_headless/.config/nvim/lua/plugins/lualine.lua:26` (`sections.lualine_b`)

**Interfaces:**
- Consumes: `M.select()` (Task 4) and `M.current_name()` (Task 1).

- [ ] **Step 1: Add the which-key entries**

In `_headless/.config/nvim/lua/keybindings.lua`, find this existing line (currently line 99):

```lua
    { "<leader>gs",  ":lua FzfLua.combine({ pickers = 'git_status' })<CR>",                                                                                                                      desc = "History" },
```

Add these two lines immediately after it:

```lua
    { "<leader>gw",  group = "Worktree" },
    { "<leader>gws", function() require("git_worktree").select() end,                                                                                                                            desc = "Switch worktree" },
```

- [ ] **Step 2: Add the lualine component**

In `_headless/.config/nvim/lua/plugins/lualine.lua`, change:

```lua
      lualine_b = { 'branch', 'diff', 'diagnostics' },
```

to:

```lua
      lualine_b = { 'branch', function() return require("git_worktree").current_name() or "" end, 'diff', 'diagnostics' },
```

- [ ] **Step 3: Verify the full nvim config still loads without errors**

```bash
nvim --headless --clean -u /home/nazarov/dotfiles/_headless/.config/nvim/init.lua -c "qa!" 2>&1
```

Expected: no Lua tracebacks printed (lazy.nvim may print plugin-install output on first run; that's fine — look specifically for `Error` or a stack trace mentioning `git_worktree.lua`, `keybindings.lua`, or `lualine.lua`).

- [ ] **Step 4: Commit**

```bash
git add _headless/.config/nvim/lua/keybindings.lua _headless/.config/nvim/lua/plugins/lualine.lua
git commit -m "feat: bind <leader>gws and show worktree name in lualine"
```

---

## Task 6: Manual end-to-end verification

**Files:** none (verification only, no code changes).

This exercises the real interactive path (`fzf-lua`'s picker UI) that Task 4 couldn't cover headlessly, against a real worktree in this repo. `worktrees/test1` already exists on disk but is **not currently registered** with git on this host (its `.git` file points at a devcontainer path, `/workspaces/dotfiles/.git/worktrees/test1`, and `git worktree list` doesn't show it) — so re-register it first rather than relying on it as-is.

- [ ] **Step 1: Re-register (or create) a real worktree to test against**

```bash
cd /home/nazarov/dotfiles
git worktree list
```

If `worktrees/test1` doesn't appear in that list, either repair it (`worktrees/test1` already has files on disk from a prior devcontainer session — use the repair path) or just create a fresh disposable one for this verification pass, e.g.:

```bash
git worktree add worktrees/verify-gws -b verify-gws --quiet
```

- [ ] **Step 2: Launch real nvim from the main worktree and check the statusline**

```bash
nvim
```

Confirm: no worktree name appears in the statusline (you're in `main`).

- [ ] **Step 3: Run the picker**

Press `<leader>gws`. Confirm: the fzf-lua picker opens and lists `main  (main)` and `verify-gws  (verify-gws)` (or whatever worktrees actually exist).

- [ ] **Step 4: Select the non-main worktree**

Confirm: all buffers close, `:pwd` reports the `worktrees/verify-gws` path, and the statusline now shows `verify-gws`.

- [ ] **Step 5: Switch back to main**

Press `<leader>gws` again, select `main  (main)`. Confirm: the statusline indicator disappears.

- [ ] **Step 6: Verify the unsaved-changes guard**

Open any file, make an edit, don't save it. Press `<leader>gws` and pick another worktree. Confirm: nvim shows a warning notification and does **not** switch (buffer stays open, `:pwd` unchanged).

- [ ] **Step 7: Verify the guard clears**

Save or discard the edit (`:w` or `:e!`), retry the same `<leader>gws` switch. Confirm: it now succeeds.

- [ ] **Step 8: Clean up the disposable verification worktree (if created in Step 1)**

```bash
git worktree remove --force worktrees/verify-gws
```
