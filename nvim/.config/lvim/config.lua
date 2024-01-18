-- Read the docs: https://www.lunarvim.org/docs/configuration
-- Video Tutorials: https://www.youtube.com/watch?v=sFA9kX-Ud_c&list=PLhoH5vyxr6QqGu0i7tt_XoVK9v-KvZ3m6
-- Forum: https://www.reddit.com/r/lunarvim/
-- Discord: https://discord.com/invite/Xb9B4Ny
local homeDir = os.getenv("HOME")
vim.api.nvim_command('set spell')
vim.opt.foldcolumn = '1' -- '0' is not bad
vim.opt.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
vim.opt.foldlevelstart = 99
vim.opt.foldenable = true
vim.opt.foldmethod           = "expr"
vim.opt.foldexpr             = "nvim_treesitter#foldexpr()"
lvim.plugins = {
  -- Core 
  "nvimtools/none-ls.nvim",
  "nvim-lua/plenary.nvim",
  "akinsho/toggleterm.nvim",
  "christoomey/vim-tmux-navigator",
  -- Navigation 
  "jrop/mongo.nvim",
  {
    "lmburns/lf.nvim",
    config = function ()
      require("lf").setup({})
    end
  },
  {
    "ibhagwan/fzf-lua",
   -- requires = { "kyazdani42/nvim-web-devicons" },
    config = function ()
      require('fzf-lua').setup({
        files = {
          previewer = "bat",
        }
      })
    end
  },
  -- Complition
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
    config = function ()
      require("copilot_cmp").setup()
    end
  },
  {
    "tyru/open-browser-github.vim", 
    dependencies = { "tyru/open-browser.vim" },
  },
  -- Debug 
  "nvim-telescope/telescope-dap.nvim",
  {
    "mxsdev/nvim-dap-vscode-js",
    config =function ()

      require("dap-vscode-js").setup({
        debugger_path = homeDir .. "/apps/vscode-js-debug",
      	adapters = { "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost" }, -- which adapters to register in nvim-dap
      })
    end
  },
  "mfussenegger/nvim-dap-python",
}

-- Keybindings 

lvim.builtin.which_key.vmappings["f"] = {
  "<cmd>lua vim.lsp.buf.format { async = true }<CR>",
  "Format selected"
}

lvim.lsp.buffer_mappings.normal_mode["gd"] = {
"<cmd>FzfLua lsp_definitions <CR>",
"Go lsp_definitions"
}
lvim.lsp.buffer_mappings.normal_mode["gr"] = {
  "<cmd>FzfLua lsp_references <CR>",
  "Go references"
}
lvim.builtin.which_key.mappings["h"] = {
  "<cmd> FzfLua buffers <CR>",
  "Recent"
}
lvim.builtin.which_key.mappings["p"] = {
    "<cmd>FzfLua commands<CR>",
    "Command pallete"
}
lvim.builtin.which_key.mappings["o"] = {
    "<cmd>FzfLua git_files<CR>",
    "Git wached files"
}
lvim.builtin.which_key.mappings["O"] = {
  name = "Open",
  o = {
    "<cmd>FzfLua git_files<CR>",
    "Git wached files"
  },
  f = {
    "<cmd>FzfLua files<CR>",
    "All files",
  },
  h = {
    "<cmd> FzfLua buffers <CR>",
    "History/Recent/Buffers"
  },
  g = {
    "<cmd> FzfLua git_status <CR>",
    "Changed files"
  },
  G = {
    "<cmd> OpenGithubFile <CR>",
    "Open on github"
  }

}
lvim.builtin.which_key.mappings["t"] = {
  name = "Toggle",
  t = {
    "<cmd> Lf<CR>",
    "File manager"
  },
  e = {
    "<cmd>ToggleDiag<CR>",
    "Errors / Diagnostics"
  }
}

lvim.builtin.which_key.mappings["f"] = {
  name = "File",
  f = {
    "<cmd>lua vim.lsp.buf.format { async = true }<CR>",
    "Format file",
  },
  S = {
    "<cmd>:wa<CR>",
    "Save all open buffers",
  },
}
lvim.builtin.which_key.mappings["e"]  = {
    name = "Errors / Diagnostics",
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
    t = {
      "<cmd>ToggleDiag<CR>",
      "Toggle",
    },
}
lvim.builtin.which_key.mappings["s"]   = {
    name = "Search",
    s = {
      "<cmd>FzfLua grep_curbuf<CR>",
      "Search in current file",
    },
    h = {
      "<cmd>FzfLua buffers<CR>",
      "History",
    },
    p = {
      "<cmd>FzfLua resume<CR>",
      "Previous",
    },
    f = {
      "<cmd>FzfLua files<CR>",
      "Files",
    },
    F = {
      "<cmd>FzfLua grep_project<CR>",
      "Files Content",
    },
    k = {
      "<cmd>FzfLua keymaps<CR>",
      "Keymaps",
    },

    b = {
      "<cmd>FzfLua dap_breakpoints<CR>",
      "List breakpoints",
    },
    M = { "<cmd>FzfLua man_pages<cr>", "Man Pages" },
    C = { "<cmd>FzfLua colorscheme<cr>", "Colorscheme" },
    H = { "<cmd>FzfLua help_tags<cr>", "Find Help" },
  }
lvim.builtin.which_key.mappings["d"] = {
  name = "Debug",
  b = { "<cmd>lua require'dap'.toggle_breakpoint()<cr>", "Toggle Breakpoint" },
  B = {
    "<cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint conditioin))<CR>",
    "Set condidional breakpoint"
  },
  ["Left"] = { "<cmd>lua require'dap'.step_back()<cr>", "Step Back" },
  ["Down"] = { "<cmd>lua require'dap'.step_into()<cr>", "Step Into" },
  ["Up"] = { "<cmd>lua require'dap'.step_out()<cr>", "Step Out" },
  ["Right"] = { "<cmd>lua require'dap'.step_over()<cr>", "Step Over" },
  i = {
    "<cmd>lua require('dapui').eval(nil, {enter=true})<CR>",
    "Inspect"
  },
  c = { "<cmd>lua require'dap'.continue()<cr>", "Continue" },
  C = { "<cmd>lua require'dap'.run_to_cursor()<cr>", "Run To Cursor" },
  d = { "<cmd>lua require'dap'.disconnect()<cr>", "Disconnect" },
  g = { "<cmd>lua require'dap'.session()<cr>", "Get Session" },
  p = { "<cmd>lua require'dap'.pause()<cr>", "Pause" },
  r = { "<cmd>lua require'dap'.repl.toggle()<cr>", "Toggle Repl" },
  s = { "<cmd>lua require'dap'.continue()<cr>", "Start" },
  q = { "<cmd>lua require'dap'.close()<cr>", "Quit" },
  U = { "<cmd>lua require'dapui'.toggle({reset = true})<cr>", "Toggle UI" },
}

-- Null LS 

local null_ls = require("null-ls")

local sources = {
  null_ls.builtins.formatting.stylua,
  null_ls.builtins.formatting.prettier,
  null_ls.builtins.completion.spell,
}
-- Add biome source if biome.json is present
local biome_config_path = vim.fn.stdpath("config") .. "/biome.json"
if vim.fn.filereadable(biome_config_path) == 1 then
  table.insert(sources, null_ls.builtins.formatting.biome)
end

-- Add eslint source if .eslintrc.js is present
local eslint_config_path = vim.fn.getcwd() .. "/.eslintrc.js"
if vim.fn.filereadable(eslint_config_path) == 1 then
  table.insert(sources, null_ls.builtins.formatting.eslint)
  table.insert(sources, null_ls.builtins.diagnostics.eslint)
end

    -- null_ls.builtins.formatting.eslint,
    -- null_ls.builtins.diagnostics.eslint,
    -- null_ls.builtins.formatting.biome, 

null_ls.setup({
  sources = sources,
})
-- DAP 

--require("dapui").setup()
-- require("mxsdev/nvim-dap-vscode-js").setup({
-- 	adapters = { "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost" }, -- which adapters to register in nvim-dap
-- })
for _, language in ipairs({ "typescript", "javascript", "vue" }) do
	local yarnPathHandle = io.popen("which yarn")
	local yarnPathWithSpace = yarnPathHandle:read("*a")
	yarnPathHandle:close()
	yarnPath = string.gsub(yarnPathWithSpace, "\n", "")
	require("dap").configurations[language] = {
		{
			type = "pwa-node",
			request = "attach",
			name = "Attach",
			protocol = inspector,
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
		},{
      type = "pwa-chrome",
      request= "launch",
      name = "client: chrome",
      url = "http://localhost:4000",
      webRoot =  "${workspaceFolder}"
    }
	}
end
