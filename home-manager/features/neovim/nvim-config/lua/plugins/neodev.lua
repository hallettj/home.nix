return {
  'folke/neodev.nvim',
  dependencies = {
    'neovim/nvim-lspconfig',
  },
  opts = {
    library = {
      plugins = {
        'neotest',
      },
      types = true,
    }
  },
}
