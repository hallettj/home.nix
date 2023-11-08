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

    local dap = {}
    local extension_path = vim.env.VSCODE_LLDB_PATH -- this variable set in neovim/default.nix
    if extension_path ~= nil then
      local codelldb_path = extension_path .. '/adapter/codelldb'
      local liblldb_path = extension_path .. '/lldb/lib/liblldb.so'
      dap.adapter = require('rust-tools.dap').get_codelldb_adapter(codelldb_path, liblldb_path)
    end

    require('rust-tools').setup {
      tools = {
        inlay_hints = {
          -- Disable inlay hints by default because we get them from
          -- lsp-inlayhints.
          auto = false,
        },
      },
      server = rust_lsp,
      dap = dap,
    }
  end
}
