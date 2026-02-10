return {
  "folke/flash.nvim",
  event = "VeryLazy",
  opts = {
    -- You can customize labels or behavior here
    labels = "asdfghjklqwertyuiopzxcvbnm",
    search = {
      mode = "search",
    },
  },
  keys = {
    -- Map 'f' to jump forward
    { "f", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
    -- Map 'F' to jump backward (Flash handles directionality automatically, 
    -- but usually people like 'F' for consistency)
    { "F", mode = { "n", "x", "o" }, function() require("flash").jump({
        search = { forward = false, wrap = false, multi_window = false },
      }) end, desc = "Flash Backward" 
    },
    -- Treesitter Selection (Highly recommended)
    { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
  },
}
