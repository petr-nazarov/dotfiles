return {
      "nvimtools/none-ls.nvim",
      dependencies = {
        "nvim-lua/plenary.nvim",
        "williamboman/mason-lspconfig.nvim",
        "williamboman/mason.nvim",
        "neovim/nvim-lspconfig",
        "nvimtools/none-ls-extras.nvim",
        "MunifTanjim/nui.nvim",
        {
        "nvim-treesitter/nvim-treesitter-context",
          opts = { mode = "cursor", max_lines = 3 },
          keys = {
            {
              "<leader>ts",
              function()
                local tsc = require("treesitter-context")
                tsc.toggle()
                if LazyVim.inject.get_upvalue(tsc.toggle, "enabled") then
                  LazyVim.info("Enabled Treesitter Context", { title = "Option" })
                else
                  LazyVim.warn("Disabled Treesitter Context", { title = "Option" })
                end
              end,
              desc = "Toggle Treesitter Context",
            },
          },
        }

      },
      config = function()
        local lspconfig = require("lspconfig")
        local null_ls = require("null-ls")
        require("mason").setup({})
        require("mason-lspconfig").setup({
          ensure_installed = {
            -- Lua
            "lua_ls",
            -- Bash
            "bashls",
            -- Html / Css
            "html",
            "astro",
            "emmet_ls",
            ----'tailwindcss',
            -- JS / TS
            "tsserver",
            -- Go
            "gopls",
            -- Markdown
            "marksman",
            -- Nix 
            "nil_ls"
          },
        })
        require("mason-lspconfig").setup_handlers({
          function(server)
            lspconfig[server].setup({})
          end,
        })
        -- Null ls
        local sources = {
          null_ls.builtins.formatting.stylua,
          null_ls.builtins.completion.spell,
        }
        -- Add biome source if biome.json is present
        local biome_config_path = vim.fn.getcwd() .. "/biome.json"
        if vim.fn.filereadable(biome_config_path) == 1 then
          table.insert(sources, null_ls.builtins.formatting.biome)
        end

        -- Add eslint source if .eslintrc.js is present
        local eslint_config_path = vim.fn.getcwd() .. "/.eslintrc.js"
        if vim.fn.filereadable(eslint_config_path) == 1 then
          table.insert(sources, require('none-ls.formatting.eslint'))
          table.insert(sources, require('none-ls.diagnostics.eslint_d'))
        end

        -- Add prettier source if .prettierrc is present
        local prettier_config_path = vim.fn.getcwd() .. "/.prettierrc"
        if vim.fn.filereadable(prettier_config_path) == 1 then
          table.insert(sources, null_ls.builtins.formatting.prettier)
        end
        require("null-ls").setup({
            sources =  sources
          })
      end,
  }
