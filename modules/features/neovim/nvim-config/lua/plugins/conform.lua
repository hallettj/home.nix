-- Code formatting
return {
  'stevearc/conform.nvim',
  opts = {
    formatters_by_ft = {
      javascript = { "prettierd", "prettier", stop_after_first = true },
      typescript = { "prettierd", "prettier", stop_after_first = true },
      nix = { "nixfmt" },
      python = { 'black' },
      sql = { "sqlfluff" },
      yaml = { 'prettier' },
      -- ["*"] = { "injected", "codespell" }, -- "injected" applies formatting to treesitter language injection regions
      ["*"] = { "codespell" },
      ["_"] = { "trim_whitespace" },
    },
  },
}
