return {
  'ldelossa/gh.nvim',
  dependencies = {
    { 'ldelossa/litee.nvim' },
    { 'nvim-telescope/telescope.nvim' }
  },
  config = function()
    require('litee.lib').setup()
    require('litee.gh').setup({})
  end,
}
