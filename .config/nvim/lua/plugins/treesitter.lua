return {
  'nvim-treesitter/nvim-treesitter',
  config = function()
    require'nvim-treesitter.configs'.setup {
      ensure_installed = {"go", "c", "lua", "rust", "javascript", "jsdoc", "json", "json5", "bash", "css", "gitignore", "python", "regex", "scss", "sql", "typescript", "vim", "vue","yaml", "tsx" }
    }
  end
}
