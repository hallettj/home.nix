return {
  'folke/trouble.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  keys = {
    { '<leader>xw', '<cmd>Trouble diagnostics toggle<cr>',                        desc = 'workspace diagnostics' },
    { '<leader>xb', '<cmd>Trouble diagnostics toggle filter.buf=0<cr>',           desc = 'buffer diagnostics' },
    { '<leader>xc', '<cmd>Trouble close<cr>',                                     desc = 'close trouble diagnostics' },
    { '<leader>cs', '<cmd>Trouble symbols toggle<cr>',                            desc = 'symbols overview sidebar' },
    { '<leader>cl', '<cmd>Trouble lsp toggle focus=false win.position=right<cr>', desc = 'LSP info sidebar' },
  },
  opts = {},
}
