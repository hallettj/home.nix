-- Configuration to make lsp-inlayhints.nvim work with TypeScript
local ts_ls = {
  inlayHints = {
    includeInlayParameterNameHints = 'all',
    includeInlayParameterNameHintsWhenArgumentMatchesName = false,
    includeInlayFunctionParameterTypeHints = true,
    includeInlayVariableTypeHints = true,
    includeInlayPropertyDeclarationTypeHints = true,
    includeInlayFunctionLikeReturnTypeHints = true,
    includeInlayEnumMemberValueHints = true,
  }
}

return {
  settings = {
    typescript = ts_ls,
    javascript = ts_ls,
  },
}
