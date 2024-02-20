--[[ keys.lua ]]
local wk = require("which-key")
local map = vim.api.nvim_set_keymap

local mappings = {
  w = {
    "<C-w>",
    "Window",
  },
  g = {
    name = "Go",
    d = {
      "",
      "Defenition",
    },
  },
  t = {
    name = "Toggle",
    t = {
      ":Lf<CR>",
      "Toggle Tree",
    },
    a = {
      name = "All",
      h = {
        ':execute "setlocal nonumber norelativenumber" | execute "ToggleDiagOff" | execute "Gitsigns toggle_signs false | execute "Gitsigns toggle_current_line_blame false" <CR>',
        "Hide",
      },
      s = {
        ':execute "setlocal number relativenumber" | execute "ToggleDiagOn" | execute "Gitsigns toggle_signs true | execute "Gitsigns toggle_current_line_blame true" <CR>',
        "Show",
      },
    },

    l = {
      name = "Lines",
      h = {
        ":setlocal nonumber norelativenumber<CR>",
        "Hide",
      },
      s = {
        ":setlocal number relativenumber<CR>",
        "Show",
      },
    },
    e = {
      ":ToggleDiag<CR>",
      "Errors/ Diagnostics",
    },
    g = {
      name = "Git",
      b = {
        ":Gitsigns toggle_current_line_blame <CR>",
        "Blame",
      },
      s = {
        ":Gitsigns toggle_signs<CR>",
        "Git Signs",
      },
    },
  },
  e = {
    name = "Errors / Diagnostics",
    n = {
      ":lua vim.diagnostic.goto_next()<CR>",
      "Next",
    },
    p = {
      ":lua vim.diagnostic.goto_prev()<CR>",
      "Previous",
    },
    i = {
      ":lua vim.diagnostic.open_float()<CR>",
      "Inspect",
    },
    l = {
      ":FzfLua diagnostics_workspace <CR>",
      "List",
    },
    f = {
      ":lua vim.lsp.buf.code_action()<CR>",
      "Fix / code action",
    },
    t = {
      ":ToggleDiag<CR>",
      "Toggle",
    },
  },
  f = {
    name = "Files",
    f = {
      ":: lua vim.lsp.buf.format { async = true }<CR>",
      "Format file",
    },

    s = {
      ":w<CR>",
      "Save file",
    },
    S = {
      ":wa<CR>",
      "Save all open buffers",
    },
    q = {
      ":q<CR>",
      "Quit",
    },
  },
  s = {
    name = "Search",
    s = {
      ":FzfLua grep_curbuf<CR>",
      "Search in current file",
    },
    h = {
      ":FzfLua buffers<CR>",
      "History",
    },
    p = {
      ":FzfLua resume<CR>",
      "Previous",
    },
    f = {
      ":FzfLua files<CR>",
      "Files",
    },
    F = {
      ":FzfLua grep_project<CR>",
      "Files Content",
    },
    k = {
      ":FzfLua keymaps<CR>",
      "Keymaps",
    },

    b = {
      ":FzfLua dap_breakpoints<CR>",
      "List breakpoints",
    },
  },
  h = {
    ":FzfLua buffers<CR>",
    "History",
  },
  m = {
    ":FzfLua marks<CR>",
    "Marks",
  },

  o = {
    ":FzfLua git_files<CR>",
    "Open gited file",
  },
  O = {
    ":FzfLua files<CR>",
    "Open file ignore gitignore",
  },
  p = {
    ":FzfLua commands<CR>",
    "Open command pallet",
  },
  z = {
    name = "Fold",
    R = {
      "::lua require('ufo').openAllFolds()<CR>",
      "Open all folds",
    },
    M = {
      "::lua require('ufo').closeAllFolds()<CR>",
      "Close all folds",
    },
  },
  d = {
    name = "Debug",
    l = {
      name = "List",
      b = {
        ":FzfLua dap_breakpoints <CR>",
        "List breakpoints",
      },
      e = {
        ":FzfLua dap_commands<CR>",
        "List executables / commands",
      },
      c = {
        ":FzfLua dap_configurations<CR>",
        "List configurations",
      },
      v = {
        ":FzfLua dap_variables<CR>",
        "List variables",
      },
      f = {
        ":FzfLua dap_frames<CR>",
        "List frames",
      },
    },

    b = {
      "::lua require'dap'.toggle_breakpoint()<CR>",
      "Toggle Breakpoint",
    },
    B = {
      "::lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint conditioin))<CR>",
      "Set conditional breakpoint",
    },
    i = {
      ":lua require('dapui').eval(nil, {enter=true})<CR>",
      "Inspect",
    },
    u = {
      name = "UI",
      i = {
        ":lua require'dapui'.toggle()<CR>",
        "Toggle UI",
      },
      v = {
        "::DapVirtualTextToggle <CR>",
        "Toggle Virtual text",
      },
    },
    ["<Right>"] = {
      "::lua require'dap'.step_over()<CR>",
      "Step Over",
    },
    ["<Down>"] = {
      "::lua require'dap'.step_into()<CR>",
      "Step Down/In",
    },
    ["<Up>"] = {
      "::lua require'dap'.step_out()<CR>",
      "Step Up/Out",
    },
    s = {
      name = "Step",
      o = {
        "::lua require'dap'.step_over()<CR>",
        "Step Over",
      },
      i = {
        "::lua require'dap'.step_into()<CR>",
        "Step Down/In",
      },
      u = {
        "::lua require'dap'.step_out()<CR>",
        "Step Up/Out",
      },
    },
    c = {
      "::lua require'dap'.continue()<CR>",
      "Continue / Start Debugging",
    },
    q = {
      "::lua require'dap'.close()<CR>",
      "Quit Debugging",
    },
  },
  m = {
    name = "Modify",
    r = {
      ":lua vim.lsp.buf.rename()<CR>",
      "rename",
    },
  },
}
local opts = {
  prefix = "<leader>",
}
wk.register(mappings, opts)

map("n", "gd", [[: FzfLua lsp_definitions<CR>]], {})
map("n", "gr", [[: FzfLua lsp_references<CR>]], {})
map("n", "K", [[:: lua vim.lsp.buf.hover()<CR>]], {})
