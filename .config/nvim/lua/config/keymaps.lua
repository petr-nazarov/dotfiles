-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- local wk = require("which-key")
-- Add any additional keymaps here
--wk.register({
--  ["<leader>t"] = { name = "+Toggle" },
--})

vim.keymap.del("n", "<leader>ww")
vim.keymap.del("n", "<leader>wd")
vim.keymap.del("n", "<leader>w-")
vim.keymap.del("n", "<leader>w|")

vim.keymap.del("n", "<leader>ff")
