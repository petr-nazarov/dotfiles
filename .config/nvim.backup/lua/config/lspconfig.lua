local lspconfig = require("lspconfig")

local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
	local hl = "DiagnosticSign" .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end
vim.diagnostic.config({
	underline = false,
	virtual_text = false,
	signs = true,
	severity_sort = true,
	float = {
		source = "always",
	},
	update_in_insert = false,
})
require("mason").setup({})
require("mason-lspconfig").setup({
	ensure_installed = {
		-- Lua
		"lua_ls",
		-- Bash
		"bashls",
		-- Html / Css
		"html",
		"astro",
		"emmet_ls",
		----'tailwindcss',
		-- JS / TS
		"tsserver",
		-- Go
		"gopls",
		-- Markdown
		"marksman",
	},
})

--require('lspconfig').tsserver.setup{}
require("mason-lspconfig").setup_handlers({
	function(server)
		lspconfig[server].setup({})
	end,
})
