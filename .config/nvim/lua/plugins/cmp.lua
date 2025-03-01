return {
	"hrsh7th/nvim-cmp",
	dependencies = {
		"neovim/nvim-lspconfig",
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-cmdline",
		"hrsh7th/vim-vsnip",
		"hrsh7th/cmp-vsnip",
		{ "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
		-- {
		-- 	"CopilotC-Nvim/CopilotChat.nvim",
		-- 	branch = "canary",
		-- },
		"zbirenbaum/copilot.lua",
		"zbirenbaum/copilot-cmp",
		-- Snippets
		"rafamadriz/friendly-snippets",
		-- Autopairs
		{
			"echasnovski/mini.pairs",
			opts = {},
		},
		-- Comments
		{
			"folke/ts-comments.nvim",
			opts = {},
		},
		-- Autotag
		{
			"windwp/nvim-ts-autotag",
			opts = {
				-- your configuration comes here
				-- or leave it empty to use the default settings
				-- refer to the configuration section below
			},
		},
		-- Chat gpt
		-- {
		--   "robitx/gp.nvim",
		--   config = function()
		--     local conf = {
		--       -- For customization, refer to Install > Configuration in the Documentation/Readme
		--     }
		--     require("gp").setup({
		--       providers = {
		--         openai = {
		--           endpoint = "https://api.openai.com/v1/chat/completions",
		--           secret = os.getenv("OPENAI_API_KEY"),
		--         },
		--       },
		--     })
		--
		--     -- Setup shortcuts here (see Usage > Shortcuts in the Documentation/Readme)
		--   end,
		-- },
	},
	config = function()
		local cmp = require("cmp")
		cmp.setup({
			snippet = {
				-- REQUIRED - you must specify a snippet engine
				expand = function(args)
					vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
				end,
			},
			window = {
				completion = cmp.config.window.bordered(),
				documentation = cmp.config.window.bordered(),
			},
			mapping = cmp.mapping.preset.insert({
				["<C-u>"] = cmp.mapping.scroll_docs(-4),
				["<C-d>"] = cmp.mapping.scroll_docs(4),
				["<C-Space>"] = cmp.mapping.complete(),
				["<C-e>"] = cmp.mapping.abort(),
				["<Tab>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
				["<CR>"] = cmp.mapping.confirm({ select = false }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
			}),

			sources = cmp.config.sources({
				-- Copilot Source
				{ name = "copilot", group_index = 2 },
				{ name = "nvim_lsp" },
				{ name = "vsnip" }, -- For vsnip users.
				-- { name = 'luasnip' }, -- For luasnip users.
				-- { name = 'ultisnips' }, -- For ultisnips users.
				-- { name = 'snippy' }, -- For snippy users.
			}, {
				{ name = "buffer" },
			}),
		})

		-- Copilot
		require("copilot").setup({
			-- It is recommended to disable copilot.lua's suggestion and panel modules, as they can interfere with completions properly appearing in copilot-cmp. To do so, simply place the following in your copilot.lua config:
			suggestion = { enabled = false },
			panel = { enabled = false },
		})
		require("copilot_cmp").setup()
	end,
}
