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
wk.add(
  {
    { "<leader>/",  ":CommentToggle<CR>", desc = "Comment" },
    { "<leader>Q",  group = "Quit" },
    { "<leader>QQ", ":qa<CR>",            desc = "Quit All" },
    { "<leader>Qb", ":1,$bd!<CR>",        desc = "Buffers" },
    { "<leader>Qq", ":q<CR>",             desc = "Quit" },
    { "<leader>W",  "<cmd> :w <CR>",      desc = "Save " },




    { "<leader>d",  group = "Debug" },
    {
      "<leader>dy",
      function()
        local file = vim.fn.expand("%:p") -- Absolute pa
        local line = vim.fn.line(".")
        local cmd = string.format("b %s:%s", file, line)
        vim.fn.setreg("+", cmd)   -- Yank to system clipboard
        vim.notify("Yanked: " .. cmd) -- Visual feedback
      end,
      desc = "Yank pdb command"
    },

    { "<leader>e",   group = "Errors / Diagnostics" },
    { "<leader>ef",  ":lua vim.lsp.buf.code_action()<CR>",                                                                                                                                       desc = "Fix / code action" },
    { "<leader>ei",  ":lua vim.diagnostic.open_float()<CR>",                                                                                                                                     desc = "Inspect" },
    { "<leader>el",  ":FzfLua diagnostics_workspace <CR>",                                                                                                                                       desc = "List" },
    { "<leader>en",  ":lua vim.diagnostic.goto_next()<CR>",                                                                                                                                      desc = "Next" },
    { "<leader>ep",  ":lua vim.diagnostic.goto_prev()<CR>",                                                                                                                                      desc = "Previous" },
    { "<leader>et",  ":ToggleDiag<CR>",                                                                                                                                                          desc = "Toggle" },
    { "<leader>f",   group = "Files" },
    { "<leader>fS",  ":wa<CR>",                                                                                                                                                                  desc = "Save all open buffers" },
    { "<leader>ff",  ":: lua vim.lsp.buf.format { async = true }<CR>",                                                                                                                           desc = "Format file" },
    { "<leader>fs",  ":w<CR>",                                                                                                                                                                   desc = "Save file" },
    { "<leader>g",   group = "Git" },
    { "<leader>gb",  "<cmd>lua require 'gitsigns'.blame_line()<cr>",                                                                                                                             desc = "Blame" },
    { "<leader>gn",  "<cmd>lua require 'gitsigns'.next_hunk({navigation_message = false})<cr>",                                                                                                  desc = "Next Hunk" },
    { "<leader>gp",  "<cmd>lua require 'gitsigns'.prev_hunk({navigation_message = false})<cr>",                                                                                                  desc = "Prev Hunk" },
    { "<leader>gs",   ":lua FzfLua.combine({ pickers = 'git_status' })<CR>",                                                                                                               desc = "History" },
    { "<leader>h",   ":lua FzfLua.combine({ pickers = 'buffers;oldfiles;' })<CR>",                                                                                                               desc = "History" },
    { "<leader>m",   ":FzfLua marks<CR>",                                                                                                                                                        desc = "Marks" },
    { "<leader>O",   ":lua FzfLua.combine({ pickers = 'files' })<CR>",                                                                                                                           desc = "Open file" },
    { "<leader>o",   ":lua FzfLua.combine({ pickers = 'buffers;git_files;oldfiles' })<CR>",                                                                                                      desc = "Open git file" },
    { "<leader>p",   ":FzfLua commands<CR>",                                                                                                                                                     desc = "Open command pallet" },
    { "<leader>q",   ":q<CR>",                                                                                                                                                                   desc = "Quit" },
    { "<leader>r",   ":lua require('persistence').load()<CR>",                                                                                                                                   desc = "Restore last session" },
    { "<leader>s",   group = "Search" },
    { "<leader>sF",  ":FzfLua grep_project<CR>",                                                                                                                                                 desc = "Files Content" },
    { "<leader>sb",  ":FzfLua dap_breakpoints<CR>",                                                                                                                                              desc = "List breakpoints" },
    { "<leader>sf",  ":FzfLua files<CR>",                                                                                                                                                        desc = "Files" },
    { "<leader>sh",  ":lua FzfLua.combine({ pickers = 'buffers;oldfiles;' })<CR>",                                                                                                               desc = "History" },
    { "<leader>sk",  ":FzfLua keymaps<CR>",                                                                                                                                                      desc = "Keymaps" },
    { "<leader>sp",  ":FzfLua resume<CR>",                                                                                                                                                       desc = "Previous" },
    { "<leader>ss",  ":FzfLua grep_curbuf<CR>",                                                                                                                                                  desc = "Search in current file" },
    { "<leader>sw",  ":lua FzfLua.grep_cword()<CR>",                                                                                                                                             desc = "Word under cursor" },
    { "<leader>sw",  ":lua FzfLua.grep_cword()<CR>",                                                                                                                                             desc = "Visual selection" },
    { "<leader>t",   group = "Toggle" },
    { "<leader>ta",  group = "All" },
    { "<leader>tah", ':execute "setlocal nonumber norelativenumber" | execute "ToggleDiagOff" | execute "Gitsigns toggle_signs false | execute "Gitsigns toggle_current_line_blame false" <CR>', desc = "Hide" },
    { "<leader>tas", ':execute "setlocal number relativenumber" | execute "ToggleDiagOn" | execute "Gitsigns toggle_signs true | execute "Gitsigns toggle_current_line_blame true" <CR>',        desc = "Show" },
    { "<leader>tc",  ":lua require('toggle-checkbox').toggle()<CR>",                                                                                                                             desc = "Toggle checkbox" },
    { "<leader>te",  ":ToggleDiag<CR>",                                                                                                                                                          desc = "Errors/ Diagnostics" },
    { "<leader>tl",  group = "Lines" },
    { "<leader>tlh", ":setlocal nonumber norelativenumber<CR>",                                                                                                                                  desc = "Hide" },
    { "<leader>tls", ":setlocal number relativenumber<CR>",                                                                                                                                      desc = "Show" },
    { "<leader>tt",  "<cmd> FloatermNew --opener=edit yazi <CR>",                                                                                                                                desc = "File manager" },
    { "<leader>w",   "<cmd> :wa <CR>",                                                                                                                                                           desc = "Save all" },
    { "<leader>y",   group = "Yank" },
    { "<leader>yF",  "<cmd> let @+ = expand('%:p') <CR>",                                                                                                                                        desc = "Yank full file path" },
    { "<leader>yf",  "<cmd> let @+ = expand('%') <CR>",                                                                                                                                          desc = "Yank relative file path" },
    { "<leader>z",   group = "Fold" },
    { "<leader>zM",  "::lua require('ufo').closeAllFolds()<CR>",                                                                                                                                 desc = "Close all folds" },
    { "<leader>zR",  "::lua require('ufo').openAllFolds()<CR>",                                                                                                                                  desc = "Open all folds" },
    { "<leader>/",   ":CommentToggle<CR>",                                                                                                                                                       desc = "Comment",                mode = "v" },

  }
)

local map = vim.api.nvim_set_keymap
-- Paste over visual selection without losing the current clipboard buffer
vim.keymap.set("x", "p", [["_dP]])
map("n", "<C-w>m", [[: tab split<CR>]], {})
map("n", "gd", [[: FzfLua lsp_definitions<CR>]], {})
map("n", "gr", [[: FzfLua lsp_references<CR>]], {})
map("n", "K", [[:: lua vim.lsp.buf.hover()<CR>]], {})
