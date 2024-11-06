local wk = require("which-key")

copilot_bindings = {
  name = "Copilot",
  c = {
 -- ":lua require('CopilotChat').toggle({ window = { layout = 'vertical', title = 'Copilot' } })  <CR>",
    ": CopilotChatToggle <CR>",
    "Chat Open",
  },
  d = {
    -- ":lua require('CopilotChat').toggle({ window = { layout = 'vertical', title = 'Copilot',   prompt = '/COPILOT_GENERATE Please add documentation comment for the selection.' } })  <CR>",
    ": CopilotChatDocs <CR>",
    "Chat Docs",
  },
  e = {
    -- ":lua require('CopilotChat').toggle({ window = { layout = 'vertical', title = 'Copilot',   prompt = '/COPILOT_EXPLAIN Write an explanation for the active selection as paragraphs of text.' } })  <CR>",
    ": CopilotChatExplain <CR>",
    "Chat explain",
  },
  f = {
    -- ":lua require('CopilotChat').toggle({ window = { layout = 'vertical', title = 'Copilot',   prompt = '/COPILOT_GENERATE There is a problem in this code. Rewrite the code to show it with the bug fixed.'  } })  <CR>",
    ": CopilotChatFix <CR>",
    "Chat Fix",
  },
  g = {
    -- ":lua require('CopilotChat').toggle({ window = { layout = 'vertical', title = 'Copilot',    prompt = 'Write commit message for the change with commitizen convention. Make sure the title has maximum 50 characters and message is wrapped at 72 characters. Wrap the whole message in code block with language gitcommit. follow conventional commits', selection = select.gitdiff } })  <CR>",
    ": CopilotChatCommit <CR>",
    "Chat Git Commit",
  },
  t = {
    -- ":lua require('CopilotChat').toggle({ window = { layout = 'vertical', title = 'Copilot',      prompt = '/COPILOT_GENERATE Please generate tests for my code.'  } })  <CR>",
    ": CopilotChatTests <CR>",
    "Chat Tests",
  },
}
wk.register({
  c = copilot_bindings,
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
      w = {
        ":lua  require'dap.ui.widgets'.hover() <CR>",
        "Widgets",
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
  },
  g = {
    name = "Git",
    j = { "<cmd>lua require 'gitsigns'.next_hunk({navigation_message = false})<cr>", "Next Hunk" },
    k = { "<cmd>lua require 'gitsigns'.prev_hunk({navigation_message = false})<cr>", "Prev Hunk" },
    b = { "<cmd>lua require 'gitsigns'.blame_line()<cr>", "Blame" },
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
  r = {
    ":lua require('persistence').load()<CR>",
    "Restore last session",
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
  t = {
    name = "Toggle",
    t = {
      "<cmd> FloatermNew --opener=edit yazi <CR>",
      "File manager",
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
  },
  w = {
    "<cmd> :wa <CR>",
    "Save all",
  },
  W = {
    "<cmd> :w <CR>",
    "Save ",
  },
  q = {
    ":q<CR>",
    "Quit",
  },
  Q = {
    name = "Quit",
    b = {
      ":1,$bd!<CR>",
      "Buffers",
    },
    q = {
      ":q<CR>",
      "Quit",
    },
    Q = {
      ":qa<CR>",
      "Quit All",
    },
  },
  y = {
    name = "Yank",
    f = {
      "<cmd> let @+ = expand('%')  <CR>",
      "Yank relative file path",
    },
    F = {
      "<cmd> let @+ = expand('%:p')  <CR>",
      "Yank full file path",
    },
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
  ["/"] = {
    ":CommentToggle<CR>",
    "Comment",
  },
}, { prefix = "<leader>" })

wk.register({
  c = copilot_bindings,
  ["/"] = {
    ":CommentToggle<CR>",
    "Comment",
  },
}, { prefix = "<leader>", mode = "v" })

local map = vim.api.nvim_set_keymap
map("n", "<C-w>m", [[: tab split<CR>]], {})
map("n", "gd", [[: FzfLua lsp_definitions<CR>]], {})
map("n", "gr", [[: FzfLua lsp_references<CR>]], {})
map("n", "K", [[:: lua vim.lsp.buf.hover()<CR>]], {})
