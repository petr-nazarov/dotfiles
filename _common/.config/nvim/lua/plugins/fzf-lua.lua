return {
  "ibhagwan/fzf-lua",
  -- optional for icon support
  dependencies = { "nvim-tree/nvim-web-devicons" },
  event = "VeryLazy",
  config = function()
    -- calling `setup` is optional for customization
    require("fzf-lua").setup({
      desc = "fzf with `bat` as native previewer",
      dap={},
      winopts = {
        preview = {
          default = "bat",
          title = true,
          layout = "vertical",
        },
      },
      files = { previewer = "bat" },
      grep = {
        rg_glob = true,
        glob_flag = "--iglob",
        rg_opts = "--hidden --column --line-number --no-heading --color=always --smart-case --max-columns=4096 -e",
      },
      manpages = { previewer = "man_native" },
      helptags = { previewer = "help_native" },
      tags = { previewer = "bat" },
      btags = { previewer = "bat" },
    })
  end
}
