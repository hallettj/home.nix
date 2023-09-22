return {
  'jvgrootveld/telescope-zoxide',
  dependencies = {
    'nvim-lua/popup.nvim',
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope.nvim'
  },
  keys = {
    {
      '<c-g>',
      function() require('telescope').extensions.zoxide.list() end,
      mode = 'n',
      desc = 'cd to a project',
    },
  },
  config = function()
    local t = require('telescope')

    -- Configure the extension
    t.setup({
      extensions = {
        zoxide = {},
      },
    })

    -- Load the extension
    t.load_extension('zoxide')
  end
}
