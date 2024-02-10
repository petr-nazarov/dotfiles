require("fzf-lua").setup({
  desc = "fzf with `bat` as native previewer",
  winopts = {
    preview = {
      default = "bat",
      title = true,
      layout = "vertical",
    },
  },
  files = { previewer = "bat" },
  grep = {
    grep_opts = "--binary-files=without-match --line-number --recursive --color=auto --perl-regexp -e ",
    rg_opts = "--column --line-number --no-heading --color=always --smart-case --max-columns=4096  -e",
  },
  manpages = { previewer = "man_native" },
  helptags = { previewer = "help_native" },
  tags = { previewer = "bat" },
  btags = { previewer = "bat" },
})
