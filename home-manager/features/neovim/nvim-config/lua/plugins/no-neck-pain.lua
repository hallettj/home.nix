-- Auto-centers single buffer
return {
  'shortcuts/no-neck-pain.nvim',
  version = '*',
  keys = {
    { '<leader>np', mode = { 'n' }, function() require('no-neck-pain').toggle() end, desc = 'toggle No Neck Pain' },
    { '<leader>ns', mode = { 'n' }, function() require('no-neck-pain').toggle_scratchPad() end, desc = 'toggle scratch pad' },
  },
  opts = {
    width = 160,
  }
}
