local enabled = require('config.features').copilot

return {
  {
    'zbirenbaum/copilot.lua',
    enabled = enabled,
    opts = {
      suggestion = { enabled = true },
      keymap = {
        jump_prev = "[[",
        jump_next = "]]",
        accept = "<CR>",
        refresh = "gR",
        open = "<M-CR>"
      },
    },
  },
  {
    'zbirenbaum/copilot-cmp',
    enabled = enabled,
    dependencies = { 'zbirenbaum/copilot.lua' },
    opts = {},
  }
}
