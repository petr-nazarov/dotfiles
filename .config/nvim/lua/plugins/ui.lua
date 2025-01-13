return {
        { 
          "catppuccin/nvim",
            name = "catppuccin",
            config = function()
              catppuccin = require("catppuccin")
              catppuccin.setup({
                flavour = "macchiato",
                integrations = {
                  aerial = true,
                  alpha = true,
                  cmp = true,
                  dashboard = true,
                  flash = true,
                  gitsigns = true,
                  headlines = true,
                  illuminate = true,
                  indent_blankline = { enabled = true },
                  leap = true,
                  lsp_trouble = true,
                  mason = true,
                  markdown = true,
                  mini = true,
                  native_lsp = {
                    enabled = true,
                    underlines = {
                      errors = { "undercurl" },
                      hints = { "undercurl" },
                      warnings = { "undercurl" },
                      information = { "undercurl" },
                    },
                  },
                  navic = { enabled = true, custom_bg = "lualine" },
                  neotest = true,
                  neotree = true,
                  noice = true,
                  notify = true,
                  semantic_tokens = true,
                  telescope = true,
                  treesitter = true,
                  treesitter_context = true,
                  which_key = true,
                },
              })
              vim.cmd [[colorscheme catppuccin]]
            end
        },
        {
         "folke/trouble.nvim",
         opts = {
          -- your configuration comes here
          -- or leave it empty to use the default settings
          -- refer to the configuration section below
         },
        },
         {
          "lukas-reineke/indent-blankline.nvim",
          opts = {
          },
          config = function()
            local highlight = {
                "RainbowRed",
                "RainbowYellow",
                "RainbowBlue",
                "RainbowOrange",
                "RainbowGreen",
                "RainbowViolet",
                "RainbowCyan",
            }

            local hooks = require "ibl.hooks"
            -- create the highlight groups in the highlight setup hook, so they are reset
            -- every time the colorscheme changes
            hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
                vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
                vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
                vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
                vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
                vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
                vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
                vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
            end)

            require('ibl').setup({
               exclude = { filetypes = {"dashboard"} },
               -- indent = { highlight = highlight }
            })
          end,
          main = "ibl",
        },
        {
          "folke/noice.nvim",
          event = "VeryLazy",
          opts = {
             lsp = {
              override = {
                ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                ["vim.lsp.util.stylize_markdown"] = true,
                ["cmp.entry.get_documentation"] = true,
              },
            },
            presets = {
              bottom_search = true,
              command_palette = true,
              long_message_to_split = true,
              inc_rename = true,
              lsp_doc_border = false,
            },
            -- add any options here
          },
          -- dependencies = {
          --   -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
          --   "MunifTanjim/nui.nvim",
          --   }
        },
}
