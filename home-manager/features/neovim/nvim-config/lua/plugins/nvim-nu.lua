return {
  'LhKipp/nvim-nu',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
  },
  build = ':TSInstall nu',
  config = true,
}
