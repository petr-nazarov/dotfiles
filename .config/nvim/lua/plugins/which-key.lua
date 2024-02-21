return {
  {
    "folke/which-key.nvim",
    opts = {
      defaults = {
        ["<leader>t"] = {
          name = "+toggle",
          t = {
            "<cmd> FloatermNew --opener=edit yazi <CR>",
            "File manager",
          },
        },
        ["<leader>y"] = {
          name = "+yank",
          f = {
            "<cmd> let @+ = expand('%')  <CR>",
            "Yank relative file path",
          },
          F = {
            "<cmd> let @+ = expand('%:p')  <CR>",
            "Yank full file path",
          },
        },
        ["<leader>w"] = {
          "<cmd> :w <CR>",
          "save",
        },
        ["<leader>fS"] = {
          "<cmd> :wa <CR>",
          "Save all open buffers",
        },
        ["<leader>Q"] = {
          "<cmd> :qa <CR>",
          "Close all",
        },
      },
    },
  },
}
