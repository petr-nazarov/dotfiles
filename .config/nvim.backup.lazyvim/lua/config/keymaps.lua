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
-- vim.keymap.del("v", "<leader>f")

vim.keymap.set("n", "<leader>ff", "<cmd>lua vim.lsp.buf.format { async = true }<CR>", { desc = "Format file" })



vim.keymap.set("v", "<leader>f", "<cmd>lua vim.lsp.buf.format { async = true,range = {['start'] = vim.api.nvim_buf_get_mark(0, '<'),['end'] = vim.api.nvim_buf_get_mark(0, '>'), }}<CR>", { desc = "Format selected" })

