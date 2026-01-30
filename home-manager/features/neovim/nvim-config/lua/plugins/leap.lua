return {
  -- `s`/`S` command jumps forward/backward to occurrence of a pair of characters
  -- `gw` jumps to pair of characters in another window
  {
    'https://codeberg.org/andyg/leap.nvim.git',
    dependencies = { 'tpope/vim-repeat' },
    keys = {
      -- default mappings, except that I changed 'gs' to 'gw', and 's' and 'S' are inclusive motions
      { 's',  mode = { 'n', 'x', 'o' }, '<Plug>(leap-forward-to)',    desc = 'Leap forward' },
      { 'S',  mode = { 'n', 'x', 'o' }, '<Plug>(leap-backward-to)',   desc = 'Leap backward' },
      { 'x',  mode = { 'x', 'o' },      '<Plug>(leap-forward-till)',  desc = 'eXclusive leap motion forward' },
      { 'X',  mode = { 'x', 'o' },      '<Plug>(leap-backward-till)', desc = 'eXclusive leap motion backward' },
      { 'gw', mode = { 'n', 'x', 'o' }, '<Plug>(leap-from-window)',   desc = 'Leap to another window' },
    },
    config = function()
      local leap = require('leap')
      leap.opts.labels = 'uhetonaspgcrkmjwqvlzidyfxb/UHETONASPGCRKMJWQVLZIDYFXB?' -- dvorak!
    end,

  },

  -- Leap, but only up the AST
  {
    'ggandor/leap-ast.nvim',
    dependencies = { 'ggandor/leap.nvim' },
    keys = {
      { '-', mode = { 'n', 'x', 'o' }, function() require 'leap-ast'.leap() end, desc = 'leap to, or operate on a higher AST node' },
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
