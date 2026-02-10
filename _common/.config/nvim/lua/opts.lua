--[[ opts.lua ]]
local opt = vim.opt

-- [[ Context ]]
opt.clipboard = "unnamedplus" -- Sync with system clipboard
opt.confirm = true -- Confirm to save changes before exiting modified buffer
opt.cursorline = true -- Enable highlighting of the current line
opt.expandtab = true -- Use spaces instead of tabs

opt.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
opt.foldlevelstart = 99
opt.foldcolumn = "0"
opt.foldenable = true
opt.foldmethod = "expr"
opt.foldexpr = "nvim_treesitter#foldexpr()"

opt.ignorecase = true -- Ignore case
opt.mouse = "a" -- Enable mouse mode
opt.smartindent = true -- Insert indents automatically
vim.api.nvim_command("set spell")
opt.spelllang = { "en" }

-- Auto reopen changed files
vim.api.nvim_command("set autoread")

vim.api.nvim_command("set spell")

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = "number"

-- [[ Filetypes ]]
vim.api.nvim_command("filetype plugin  on")

opt.encoding = "utf8" -- str:  String encoding to use
opt.fileencoding = "utf8" -- str:  File encoding to use

-- [[ Theme ]]
opt.syntax = "ON" -- str:  Allow syntax highlighting
opt.termguicolors = true -- bool: If term supports ui color then enable
vim.o.termguicolors = true
vim.g.t_co = 256

-- [[ Search ]]
opt.ignorecase = true -- bool: Ignore case in search patterns
opt.smartcase = true -- bool: Override ignorecase if search contains capitals
opt.incsearch = true -- bool: Use incremental search
opt.hlsearch = false
-- [[ Word sepparators ]]
-- opt.iskeyword:remove('_')
-- [[ Whitespace ]]
opt.expandtab = true -- bool: Use spaces instead of tabs
opt.shiftwidth = 2 -- num:  Size of an indent
opt.softtabstop = 2 -- num:  Number of spaces tabs count for in insert mode
opt.tabstop = 2 -- num:  Number of spaces tabs count for

-- [[ Splits ]]
opt.splitright = true -- bool: Place new window to right of current one
opt.splitbelow = true -- bool: Place new window below the current one

-- auto format
vim.g.autoformat = true

-- vim.api.nvim_create_autocmd("BufWritePre", {
--   callback = function()
--     vim.lsp.buf.format({
--       filter = function(client) return client.name ~= "tsserver" end,
--       timeout_ms = 500,
--       async = true
--     })
--   end
-- })
