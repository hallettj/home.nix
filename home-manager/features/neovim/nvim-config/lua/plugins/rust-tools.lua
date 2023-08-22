return {
  'simrat39/rust-tools.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'mfussenegger/nvim-dap',
    'neovim/nvim-lspconfig',
    'VonHeikemen/lsp-zero.nvim',
  },
  config = function()
    local lsp = require('lsp-zero').preset {}

    -- Get lsp settings from lsp-zero
    local rust_lsp = lsp.build_options('rust_analyzer', {})

    require('rust-tools').setup {
      tools = {
        inlay_hints = {
          -- Disable inlay hints by default because we get them from
          -- lsp-inlayhints.
          auto = false,
        },
      },
      server = rust_lsp,
    }
  end
}
