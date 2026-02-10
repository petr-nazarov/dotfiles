return {
  "echasnovski/mini.surround",
  event = "VeryLazy",
  dependencies = {
    { 'echasnovski/mini.icons', version = '*' }
  },
  config = function()
    require("mini.surround").setup({})
  end
}
