local M = {}

function M.current_name()
  local cwd = vim.fn.getcwd()
  return cwd:match("/worktrees/([^/]+)")
end

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

return M
