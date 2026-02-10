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
        glob_flag = "--iglob"
      },
      manpages = { previewer = "man_native" },
      helptags = { previewer = "help_native" },
      tags = { previewer = "bat" },
      btags = { previewer = "bat" },
    })
  end
}
