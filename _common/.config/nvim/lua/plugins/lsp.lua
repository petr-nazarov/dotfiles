-- ~/.config/nvim/lua/plugins/lsp.lua

return {
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
      { "williamboman/mason.nvim", opts = {} },
      "neovim/nvim-lspconfig",
    },
    config = function()
      local mason_lspconfig = require("mason-lspconfig")
      -- Path to Mason's bin directory
      local mason_bin = vim.fn.stdpath("data") .. "/mason/bin/"

      -- 1. List of servers to ensure are installed
      local servers = {
        "basedpyright",
        "lua_ls",
        "bashls",
        "jsonls",
        "taplo",
        "ts_ls",
        "biome",
        "emmet_ls",
        "html",
        "cssls",
        "tailwindcss",
      }

      mason_lspconfig.setup({
        ensure_installed = servers,
        automatic_installation = true,
      })

      -- 2. Configure BasedPyright (Native 0.11 API)
      local pyright_cmd = mason_bin .. "basedpyright-langserver"
      
      -- We only initialize if Mason has finished installing the binary
      if vim.fn.executable(pyright_cmd) == 1 then
        vim.lsp.config("basedpyright", {
          cmd = { pyright_cmd, "--stdio" },
          filetypes = { "python" },
          -- ROOT DETECTION: Prioritize .git to ensure the monorepo root is used
          root_markers = { ".git", "mise.toml", "pyproject.toml",  "requirements.txt" },
          
          on_new_config = function(config, root_dir)
            -- Logic to find the Poetry virtualenv managed by Mise
            local venv_python = root_dir .. "/.venv/bin/python"
            
            -- If not found at the detected root, check if it exists at the monorepo level
            if not vim.uv.fs_stat(venv_python) then
              local monorepo_venv = vim.fn.fnamemodify(root_dir, ":p:h") .. "/.venv/bin/python"
              if vim.uv.fs_stat(monorepo_venv) then
                venv_python = monorepo_venv
              end
            end

            if vim.uv.fs_stat(venv_python) then
              config.settings.python.pythonPath = venv_python
            else
              -- Fallback to whatever 'python3' is active in your current Mise environment
              config.settings.python.pythonPath = vim.fn.exepath("python3") or "python"
            end
          end,
          settings = {
            basedpyright = {
              analysis = {
                autoSearchPaths = true,
                diagnosticMode = "openFilesOnly",
                useLibraryCodeForTypes = true,
              },
            },
            python = {
              analysis = {
                autoSearchPaths = true,
                diagnosticMode = "workspace",
              },
            },
          },
        })
        -- Enable BasedPyright
        vim.lsp.enable("basedpyright")
      end

      -- 3. Enable all other servers using the Native 0.11 way
      -- This avoids the "lspconfig framework is deprecated" warnings
      for _, server in ipairs(servers) do
        if server ~= "basedpyright" then
          vim.lsp.enable(server)
        end
      end

      -- Feedback notification
      vim.schedule(function()
        vim.notify("LSP: Native 0.11 Configured for Monorepo", vim.log.levels.INFO)
      end)
    end,
  },
}
