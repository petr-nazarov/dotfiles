local cmp = require("cmp")
return {
  {
    "zbirenbaum/copilot.lua",
    enabled = true,
    cmd = "Copilot",
    opts = {
      suggestion = { 
        accept = false,
        enabled = false, 
      },
      panel = { enabled = false },
    }
  },
  {},
  {
    "nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-emoji",
      {
        "zbirenbaum/copilot-cmp",
        opts = {},
      },
    --- @param opts cmp.ConfigSchema
      opts = function(_, opts)
        opts.sources = cmp.config.sources(vim.list_extend(opts.sources, { { name = "copilot" }, { name = "emoji" } }))
      end,
    },
    mapping = {
      ["<Tab>"] = cmp.mapping(function(fallback)
      if require("copilot.suggestion").is_visible() then
        require("copilot.suggestion").accept()
      elseif cmp.visible() then
        cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
      elseif luasnip.expandable() then
        luasnip.expand()
      elseif has_words_before() then
        cmp.complete()
      else
        fallback()
      end
      end, {
        "i",
        "s",
      }),
    }

  },
}
