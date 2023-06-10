return {
  -- `s`/`S` command jumps to occurrence of a pair of characters
  {
    'ggandor/leap.nvim',
    dependencies = { 'tpope/vim-repeat' },
    config = function()
      local leap = require('leap')
      leap.add_default_mappings()

      -- I have , and : swapped so I match that configuration in leap
      leap.opts.special_keys.prev_target = { '<tab>', ':' }
    end,

  },

  -- operate on remote pieces of text using leap motions; e.g.
  -- yar<textobject><leap>
  {
    'ggandor/leap-spooky.nvim',
    dependencies = {
      'ggandor/leap.nvim',
      'tpope/vim-repeat'
    },
    config = true,
  },

  -- Leap, but only up the AST
  {
    'ggandor/leap-ast.nvim',
    dependencies = { 'ggandor/leap.nvim' },
    keys = {
      { 'gn', function() require 'leap-ast'.leap() end, mode = { 'n', 'x', 'o' }, desc = 'leap to a higher AST node' },
    },
  }
}
