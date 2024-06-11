
require('packer').startup(function()
                     -- start screen
  use { 'DanilaMihailov/beacon.nvim' }               -- cursor jump
  
  use 'shaunsingh/nord.nvim'
  use({
	  "catppuccin/nvim",
	  as = "catppuccin"
  })
end
)
require('lualine').setup {
 
}
local catppuccin = require("catppuccin")
catppuccin.setup()
