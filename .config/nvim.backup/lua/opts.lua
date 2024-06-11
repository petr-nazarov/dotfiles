--[[ opts.lua ]]
local opt = vim.opt

-- [[ Context ]]
vim.cmd [[
set mouse=v
set clipboard=unnamedplus
]]

opt.foldcolumn = '1' -- '0' is not bad
opt.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
opt.foldlevelstart = 99
opt.foldenable = true
opt.foldmethod           = "expr"
opt.foldexpr             = "nvim_treesitter#foldexpr()"

opt.colorcolumn          = '200' -- str:  Show col for max line length
opt.number               = true  -- bool: Show line numbers
opt.relativenumber       = true  -- bool: Show relative line numbers
opt.scrolloff            = 4     -- int:  Min num lines of context
opt.signcolumn           = "yes" -- str:  Show the sign column
opt.timeoutlen           = 300

-- [[ Filetypes ]]
opt.encoding             = 'utf8' -- str:  String encoding to use
opt.fileencoding         = 'utf8' -- str:  File encoding to use

-- [[ Theme ]]
opt.syntax               = "ON"        -- str:  Allow syntax highlighting
opt.termguicolors        = true        -- bool: If term supports ui color then enable
vim.o.termguicolors      = true
vim.g.catppuccin_flavour = "macchiato" -- latte, frappe, macchiato, mocha
vim.cmd [[colorscheme catppuccin]]
-- vim.cmd[[colorscheme nord]]
vim.g.t_co = 256
vim.g.background = "dark"
--cmd('colorscheme dracula')       -- cmd:  Set the colorscheme


-- [[ Search ]]
opt.ignorecase = true -- bool: Ignore case in search patterns
opt.smartcase = true  -- bool: Override ignorecase if search contains capitals
opt.incsearch = true  -- bool: Use incremental search
opt.hlsearch = false
-- bool: Highlight search matches

-- [[ Whitespace ]]
opt.expandtab = true -- bool: Use spaces instead of tabs
opt.shiftwidth = 2   -- num:  Size of an indent
opt.softtabstop = 2  -- num:  Number of spaces tabs count for in insert mode
opt.tabstop = 2      -- num:  Number of spaces tabs count for

-- [[ Splits ]]
opt.splitright = true -- bool: Place new window to right of current one
opt.splitbelow = true -- bool: Place new window below the current one


vim.g.vim_svelte_plugin_load_full_syntax = 1
vim.g.vim_svelte_plugin_use_typescript = 1
vim.api.nvim_create_autocmd("BufWritePre", {
  callback = function()
    vim.lsp.buf.format({
      filter = function(client) return client.name ~= "tsserver" end, 
      timeout_ms = 500,
      async = true
    })
  end
})
