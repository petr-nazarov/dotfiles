local M = {}

function M.current_name()
  local cwd = vim.fn.getcwd()
  return cwd:match("/worktrees/([^/]+)")
end

return M
