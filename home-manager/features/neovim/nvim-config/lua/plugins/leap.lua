return {
  -- `s`/`S` command jumps forward/backward to occurrence of a pair of characters
  -- `gs` jumps to pair of characters in another window
  {
    'ggandor/leap.nvim',
    dependencies = { 'tpope/vim-repeat' },
    config = function()
      local leap = require('leap')

      -- `s{char1}{char2}`  leap forward,              modes = { 'x', 'o', 'n' }
      -- `S{char1}{char2}`  leap backward,             modes = { 'x', 'o', 'n' }
      -- `gs{char1}{char2}` leap to another window,    modes = { 'x', 'o', 'n' }
      -- `x{char1}{char2}`  eXclusive motion forward,  modes = { 'x', 'o', } 
      -- `X{char1}{char2}`  eXclusive motion backward, modes = { 'x', 'o', } 
      leap.add_default_mappings(true)

      leap.opts.labels = 'uhetonaspgcrkmjwqvlzidyfxb/UHETONASPGCRKMJWQVLZIDYFXB?' -- dvorak!
    end,

  },

  -- Leap, but only up the AST
  {
    'ggandor/leap-ast.nvim',
    dependencies = { 'ggandor/leap.nvim' },
    keys = {
      { '-', function() require 'leap-ast'.leap() end, mode = { 'n', 'x', 'o' }, desc = 'leap to, or operate on a higher AST node' },
    },
  },

  -- operate on remote pieces of text using leap jump as a starting point
  -- e.g., yr<leap><motion>
  {
    'rasulomaroff/telepath.nvim',
    dependencies = { 'ggandor/leap.nvim' },
    keys = {
      { 'r', mode = 'o', function() require('telepath').remote { restore = true } end,                   desc = 'operate on remote textobject, use leap search to set start point' },
      { 'R', mode = 'o', function() require('telepath').remote { restore = true, recursive = true } end, desc = 'operate on remote textobject recursively, use leap search to set start point' },
      { 'm', mode = 'o', function() require('telepath').remote() end,                                    desc = 'operate on remote textobject and move cursor there, use leap search to set start point' },
      { 'M', mode = 'o', function() require('telepath').remote { recursive = true } end,                 desc = 'operate on remote textobject recursively and move cursor there, use leap search to set start point' }
    },
  }
}
