local features = require('config.features')

return {
  'olimorris/codecompanion.nvim',
  enabled = features.codecompanion,
  event = 'VeryLazy',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',

    features.blink and {
      'saghen/blink.cmp',
      opts = {
        sources = { default = { 'codecompanion' } },
      },
    } or {}
  },
  keys = {
    { '<C-a>',          mode = { 'n' }, '<cmd>CodeCompanionActions<cr>',     silent = true, desc = 'CodeCompanion actions' },
    { '<C-a>',          mode = { 'v' }, '<cmd>CodeCompanionActions<cr>',     silent = true, desc = 'CodeCompanion actions' },
    { '<LocalLeader>a', mode = { 'n' }, '<cmd>CodeCompanionChat Toggle<cr>', silent = true, desc = 'toggle CodeCompanion chat' },
    { '<LocalLeader>a', mode = { 'v' }, '<cmd>CodeCompanionChat Toggle<cr>', silent = true, desc = 'toggle CodeCompanion chat' },
    { 'ga',             mode = { 'v' }, '<cmd>CodeCompanionChat Add<cr>',    silent = true, desc = 'add selection to CodeCompanion chat' },
  },
  config = function()
    require('codecompanion').setup {
      strategies = {
        chat = { adapter = 'anthropic' },
        inline = { adapter = 'anthropic' },
      },
    }
  end
}
