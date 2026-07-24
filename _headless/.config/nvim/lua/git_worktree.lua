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

return M
