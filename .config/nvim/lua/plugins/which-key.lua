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
        ["<leader>e"] = {
          name = "diagnostics",

          n = {
            "<cmd>lua vim.diagnostic.goto_next()<CR>",
            "Next",
          },
          p = {
            "<cmd>lua vim.diagnostic.goto_prev()<CR>",
            "Previous",
          },
          i = {
            "<cmd>lua vim.diagnostic.open_float()<CR>",
            "Inspect",
          },
          l = {
            "<cmd>FzfLua diagnostics_workspace <CR>",
            "List",
          },
          f = {
            "<cmd>lua vim.lsp.buf.code_action()<CR>",
            "Fix / code action",
          },
          e = {
            "<cmd>lua vim.diagnostic.enable()<CR>",
            "Enable",
          },
          d = {
            "<cmd>lua vim.diagnostic.disable()<CR>",
            "Disable",
          },
        },
        ["<leader>f"] = {
          name = "+file",
          f = { "<cmd>lua vim.lsp.buf.format { async = true } <cr>", "Format file" },
        },
        ["<leader>g"] = {
          name = "+git",
          j = { "<cmd>lua require 'gitsigns'.next_hunk({navigation_message = false})<cr>", "Next Hunk" },
          k = { "<cmd>lua require 'gitsigns'.prev_hunk({navigation_message = false})<cr>", "Prev Hunk" },
          b = { "<cmd>lua require 'gitsigns'.blame_line()<cr>", "Blame" },
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
