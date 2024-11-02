return {
  {
    'zbirenbaum/copilot.lua',
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
    dependencies = { 'zbirenbaum/copilot.lua' },
    opts = {},
  }
}
