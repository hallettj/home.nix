return {
  'nvim-telescope/telescope.nvim',
  dependencies = {
    { 'nvim-lua/plenary.nvim' },
    { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    { 'folke/trouble.nvim' },
    { 'kyazdani42/nvim-web-devicons' },
  },
  config = function()
    local telescope = require('telescope')
    local trouble = require('trouble.providers.telescope')

    telescope.setup {
      defaults = {
        mappings = {
          i = { ['<c-t>'] = trouble.open_with_trouble },
          n = { ['<c-t>'] = trouble.open_with_trouble },
        },
      },
    }
    telescope.load_extension('fzf')
  end,
}
