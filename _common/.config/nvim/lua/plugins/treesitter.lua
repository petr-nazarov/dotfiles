return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",  -- runs only on :Lazy install / update
  event = { "BufReadPre", "BufNewFile" },
  opts  = {
    ensure_installed = {
      "go", "c", "lua", "rust",
      "javascript", "jsdoc", "json", "json5",
      "bash", "css", "gitignore", "python", "regex",
      "scss", "sql", "typescript", "vim", "vue",
      "yaml", "tsx"
    },
    highlight        = { enable = true },
    indent           = { enable = true },
  },
}
