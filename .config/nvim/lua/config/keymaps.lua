-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
-- local wk = require("which-key")
--wk.register({
--  ["<leader>t"] = { name = "+Toggle" },
--})

vim.keymap.set("n", "<leader>tt", "<cmd> FloatermNew --opener=edit yazi <CR>", { desc = "Tree" })
