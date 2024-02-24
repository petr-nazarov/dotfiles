return {
  "nvim-telescope/telescope.nvim",
  keys = {
    -- disable the keymap to grep files
    { "<leader>/", false },
    { "<leader>sf", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
    { "<leader>sF", "<cmd>Telescope live_grep<cr>", desc = "Find Files" },
    { "<leader>ss", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Search current buffer" },
    { "<leader>sp", "<cmd>Telescope resume<cr>", desc = "Previous search" },
    --
    { "<leader>h", "<cmd>Telescope oldfiles<cr>", desc = "Open history" },
    { "<leader>p", "<cmd>Telescope autocommands<cr>", desc = "Command Palete" },
    { "<leader>o", "<cmd>Telescope git_files<cr>", desc = "Open project files" },
    { "<leader>O", "<cmd>Telescope fd<cr>", desc = "Open  file" },
    { "<leader>gf", "<cmd>Telescope git_status<cr>", desc = "Changed files" },
    { "<leader>el", "<cmd>Telescope diagnostics<cr>", desc = "Open history" },
  },
}
