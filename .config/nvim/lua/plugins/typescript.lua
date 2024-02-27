--[[
Javascript / Typescript language support
--]]

-- -- Import utility functions
-- local util = require("util")
local homeDir = os.getenv("HOME")

return {

  -- Add languages to treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed or {}, { "javascript", "jsdoc", "typescript", "tsx" })
    end,
  },

  -- Configure language server
  {
    "neovim/nvim-lspconfig",
    dependencies = { "nvimtools/none-ls.nvim" },
    opts = {
      servers = {
        tsserver = {
          keys = {
            { "<leader>cD", "<cmd>Neogen<cr>", desc = "Generate Docs", mode = { "n" } },
            {
              "<leader>co",
              function()
                vim.lsp.buf.code_action({
                  apply = true,
                  context = {
                    only = { "source.organizeImports.ts" },
                    diagnostics = {},
                  },
                })
              end,
              desc = "Organize Imports",
            },
          },
          settings = function()
            local language = {
              format = {
                indentSize = vim.o.shiftwidth,
                convertTabsToSpaces = vim.o.expandtab,
                tabSize = vim.o.tabstop,
              },
            }
            return {
              completions = { completeFunctionCalls = true },
              javascript = language,
              typescript = language,
            }
          end,
        },
      },
    },
  },

  -- Configure formatters
  -- {
  --   "stevearc/conform.nvim",
  --   opts = function(_, opts)
  --     opts.formatters_by_ft = util.formatter.set(
  --       opts.formatters_by_ft,
  --       { "javascript", "javascriptreact", "typescript", "typescriptreact" },
  --       { "eslint_d" }
  --     )
  --   end,
  -- },
  --
  -- Configure debug adapter
  {
    "mfussenegger/nvim-dap",
    optional = true,
    dependencies = {
      {
        "williamboman/mason.nvim",
        opts = function(_, opts)
          opts.ensure_installed = opts.ensure_installed or {}
          table.insert(opts.ensure_installed, "js-debug-adapter")
        end,
      },
      {
        "mxsdev/nvim-dap-vscode-js",
        config = function()
          require("dap-vscode-js").setup({
            debugger_path = homeDir .. "/apps/vscode-js-debug",
            adapters = { "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost" }, -- which adapters to register in nvim-dap
          })
        end,
      },
    },
    opts = function()
      local dap = require("dap")
      for _, language in ipairs({ "typescript", "javascript", "vue" }) do
        local yarnPathHandle = io.popen("which yarn")
        local yarnPathWithSpace = yarnPathHandle:read("*a")
        yarnPathHandle:close()
        yarnPath = string.gsub(yarnPathWithSpace, "\n", "")
        require("dap").configurations[language] = {
          {
            type = "pwa-node",
            request = "attach",
            name = "Attach 5858",
            protocol = "inspector",
            sourceMaps = true,
            trace = true,
            -- processId = require'dap.utils'.pick_process,
            --cwd = "${workspaceFolder}",
            port = 5858,
          },
          {
            type = "pwa-node",
            request = "launch",
            name = "Run jest test on file",
            cwd = vim.fn.getcwd(),
            runtimeArgs = { "--inspect-brk", yarnPath, "test", "${relativeFile}" },
            sourceMaps = true,
            protocol = "inspector",
            skipFiles = { "<node_internals>/**/*.js" },
            console = "integratedTerminal",
            port = 9229,
            -- protocol = inspector,
          },
          {
          type = "pwa-node",
          request = "launch",
          name = "Launch file",
          program = "${file}",
          cwd = "${workspaceFolder}",
        },
        {
          type = "pwa-node",
          request = "attach",
          name = "Attach select",
          processId = require("dap.utils").pick_process,
          cwd = "${workspaceFolder}",
        },
          --{
            --type = "pwa-chrome",
            --request = "launch",
            --name = "client: chrome",
            --url = "http://localhost:4000",
            --webRoot = "${workspaceFolder}",
          --},
        }
      end

      if not dap.adapters.node then
        dap.adapters.node = {
          type = "server",
          host = "localhost",
          port = "${port}",
          executable = {
            command = "node",
            args = {
              require("mason-registry").get_package("js-debug-adapter"):get_install_path()
                .. "/js-debug/src/dapDebugServer.js",
              "${port}",
            },
          },
        }
      end
      require("dap.ext.vscode").load_launchjs(nil, {
        node = { "javascript", "typescript" },
      })
    end,

    keys = {
      {
        "<leader>dB",
        function()
          require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
        end,
        desc = "Breakpoint Condition",
      },
      {
        "<leader>db",
        function()
          require("dap").toggle_breakpoint()
        end,
        desc = "Toggle Breakpoint",
      },
      {
        "<leader>dc",
        function()
          require("dap").continue()
        end,
        desc = "Continue",
      },

      {
        "<leader>d<Left>",
        function()
          require("dap").step_back()
        end,
        desc = "Step Back",
      },
      {
        "<leader>dDown",
        function()
          require("dap").step_into()
        end,
        desc = "Step Into",
      },
      {
        "<leader>dUp",
        function()
          require("dap").step_out()
        end,
        desc = "Step Out",
      },
      {
        "<leader>dRight",
        function()
          require("dap").step_over()
        end,
        desc = "Step Over",
      },
      {
        "<leader>di",
        function()
          require("dapui").eval(nil, { enter = true })
        end,
        desc = "Inspect",
      },

      {
        "<leader>da",
        function()
          require("dap").continue({ before = get_args })
        end,
        desc = "Run with Args",
      },
      {
        "<leader>dC",
        function()
          require("dap").run_to_cursor()
        end,
        desc = "Run to Cursor",
      },
      {
        "<leader>dg",
        function()
          require("dap").goto_()
        end,
        desc = "Go to line (no execute)",
      },
      {
        "<leader>dj",
        function()
          require("dap").down()
        end,
        desc = "Down",
      },
      {
        "<leader>dk",
        function()
          require("dap").up()
        end,
        desc = "Up",
      },
      {
        "<leader>dl",
        function()
          require("dap").run_last()
        end,
        desc = "Run Last",
      },
      {
        "<leader>do",
        function()
          require("dap").step_out()
        end,
        desc = "Step Out",
      },
      {
        "<leader>dO",
        function()
          require("dap").step_over()
        end,
        desc = "Step Over",
      },
      {
        "<leader>dp",
        function()
          require("dap").pause()
        end,
        desc = "Pause",
      },
      {
        "<leader>dr",
        function()
          require("dap").repl.toggle()
        end,
        desc = "Toggle REPL",
      },
      {
        "<leader>ds",
        function()
          require("dap").session()
        end,
        desc = "Session",
      },
      {
        "<leader>dt",
        function()
          require("dap").terminate()
        end,
        desc = "Terminate",
      },
      {
        "<leader>dw",
        function()
          require("dap.ui.widgets").hover()
        end,
        desc = "Widgets",
      },
    },
  },

  -- Configure test runner
  {
    "nvim-neotest/neotest",
    optional = true,
    dependencies = { "nvim-neotest/neotest-jest" },
    opts = {
      adapters = {
        ["neotest-jest"] = {
          cwd = function()
            return vim.fn.getcwd()
          end,
        },
      },
    },
  },
}
