local fn = vim.fn
--- returns the require for use in `config` parameter of packer's use
--- expects the name of the config file
local function get_config(name)
  return string.format('require("config/%s")', name)
end
local ensure_packer = function()
  local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
    vim.cmd([[packadd packer.nvim]])
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()
-- initialize and configure packer
local packer = require("packer")
packer.init({
  enable = true, -- enable profiling via :PackerCompile profile=true
  threshold = 0, -- the amount in ms that a plugins load time must be over for it to be included in the profile
  max_jobs = 20, -- Limit the number of simultaneous jobs. nil means no limit. Set to 20 in order to prevent PackerSync form being "stuck" -> https://github.com/wbthomason/packer.nvim/issues/746
  -- Have packer use a popup window
  display = {
    open_fn = function()
      return require("packer.util").float({ border = "rounded" })
    end,
  },
})

packer.startup(function(use)
  use({ "mhinz/vim-startify" })

  use({
    "catppuccin/nvim",
    as = "catppuccin",
    config = get_config("catppuccin"),
  })

  use({
    "nvim-lualine/lualine.nvim", -- statusline
    requires = {
      "kyazdani42/nvim-web-devicons",
      opt = true,
    },
    config = get_config("lualine"),
  })

  use({
    "kyazdani42/nvim-tree.lua",
    requires = "kyazdani42/nvim-web-devicons",
    config = get_config("nvim-tree"),
  })

  use({
    "windwp/nvim-autopairs",
    config = get_config("nvim-tree"),
  })

  use({
    "ibhagwan/fzf-lua",
    requires = { "kyazdani42/nvim-web-devicons" },
    config = get_config("fzf-lua"),
  })

  use({
    "lmburns/lf.nvim",
    requires = { "nvim-lua/plenary.nvim", "akinsho/toggleterm.nvim" },
    config = function()
      require("lf").setup({})
    end,
  })

  use({
    "folke/which-key.nvim",
    config = get_config("which-key"),
  })

  use({ "majutsushi/tagbar" }) -- code structure
  use({ "preservim/nerdcommenter" })
  use({
    "nvim-treesitter/nvim-treesitter",
    run = function()
      require("nvim-treesitter.install").update({ with_sync = true })
    end,
    config = get_config("nvim-treesitter"),
  })
  use({
    "leafOfTree/vim-vue-plugin",
  })
  use({
    "leafOfTree/vim-svelte-plugin",
  })

  use({
    "williamboman/mason.nvim",
    requires = { {
      "williamboman/mason-lspconfig.nvim",
    }, {
      "neovim/nvim-lspconfig",
    } },
    run = ":MasonUpdate", -- :MasonUpdate updates registry contents
    config = get_config("lspconfig"),
  })

  use({
    "jose-elias-alvarez/null-ls.nvim",
    requires = { "neovim/nvim-lspconfig", "nvim-lua/plenary.nvim" },
    config = get_config("null-ls"),
  })
  use({
    "github/copilot.vim",
  })
  use({
    "christoomey/vim-tmux-navigator",
  })
  -- Debug

  use({ "mfussenegger/nvim-dap" })
  use({ "mxsdev/nvim-dap-vscode-js", requires = { "mfussenegger/nvim-dap" } })
  use({
    "microsoft/vscode-js-debug",
    opt = true,
    run = "npm install --legacy-peer-deps && npx gulp vsDebugServerBundle && mv dist out",
  })
  use({ "nvim-telescope/telescope-dap.nvim" })
  use({ "mfussenegger/nvim-dap-python" })
  use({ "puremourning/vimspector" })
  use({ "theHamsta/nvim-dap-virtual-text" })
  use({ "rcarriga/nvim-dap-ui" })
  use({
    "numToStr/Comment.nvim",
    config = function()
      require("Comment").setup()
    end,
  })
  use({
    "RRethy/vim-illuminate",
    config = function()
      require("illuminate").configure()
    end,
  })
  use({ "tpope/vim-fugitive" })
  use({ "lewis6991/gitsigns.nvim", config = get_config("gitsigns") })
  use({
    "WhoIsSethDaniel/toggle-lsp-diagnostics.nvim",
    config = function()
      require("toggle_lsp_diagnostics").init()
    end,
  })

  use({
    "kylechui/nvim-surround",
    tag = "*", -- Use for stability; omit to use `main` branch for the latest features
    config = function()
      require("nvim-surround").setup({
        -- Configuration here, or leave empty to use defaults
      })
    end,
  })
  -- Compleation

  use({
    "hrsh7th/nvim-cmp",
    requires = {
      { "neovim/nvim-lspconfig" },
      { "hrsh7th/cmp-nvim-lsp" },
      { "hrsh7th/cmp-buffer" },
      { "hrsh7th/cmp-path" },
      { "hrsh7th/cmp-cmdline" },
      { "hrsh7th/vim-vsnip" },
      { "hrsh7th/cmp-vsnip" },
    },
    config = get_config("cmp"),
  })
  -- Language spesific
  use({ "wuelnerdotexe/vim-astro" })
  use({ "amadeus/vim-mjml" })
  vim.g.astro_typescript = "enable"
  use({ "mattn/emmet-vim" })
  use({ "darrikonn/vim-gofmt" })
  use({ "posva/vim-vue" })

  if packer_bootstrap then
    require("packer").sync()
  end
end)
