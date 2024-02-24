--[[ init.lua ]]
vim.g.mapleader = " "
vim.g.localleader = "\\"

-- IMPORTS
require('plug')      -- Plugins
require('vars')      -- Variables
require('opts')      -- Options
require('keys')      -- Keymaps

require('dbg') -- Debugging

-- PLUGINS: Add this section
vim.g.blamer_enabled = 1
