local homeDir = os.getenv("HOME")

return {
  { "nvimtools/none-ls.nvim" },
  "nvim-lua/plenary.nvim",
  "akinsho/toggleterm.nvim",
  "christoomey/vim-tmux-navigator",
  "voldikss/vim-floaterm",
  {
    "ibhagwan/fzf-lua",
    -- requires = { "kyazdani42/nvim-web-devicons" },
    config = function()
      require("fzf-lua").setup({
        files = {
          previewer = "bat",
        },
      })
    end,
  },
  {
    "tyru/open-browser-github.vim",
    dependencies = { "tyru/open-browser.vim" },
  },
  -- Compleation
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({})
    end,
  },
  {
    "zbirenbaum/copilot-cmp",
    config = function()
      require("copilot_cmp").setup()
    end,
  },
  -- Debug
  "nvim-telescope/telescope-dap.nvim",
  {
    "mxsdev/nvim-dap-vscode-js",
    config = function()
      require("dap-vscode-js").setup({
        debugger_path = homeDir .. "/apps/vscode-js-debug",
        adapters = { "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost" }, -- which adapters to register in nvim-dap
      })
    end,
  },
  "mfussenegger/nvim-dap-python",
}
