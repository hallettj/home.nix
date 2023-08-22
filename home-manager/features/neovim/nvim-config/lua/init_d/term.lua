-- To simulate |i_CTRL-R| in terminal-mode: >
vim.keymap.set('t', '<c-r>', function()
  local next_char_code = vim.fn.getchar()
  local next_char = vim.fn.nr2char(next_char_code)
  return '<C-\\><C-N>"' .. next_char .. 'pi'
end, { expr = true })

-- Key binding to enter normal mode in a terminal
vim.keymap.set('t', '<c-b>', '<c-\\><c-n>', { silent = true })

vim.api.nvim_create_autocmd('TermOpen', {
  group = vim.api.nvim_create_augroup('MyNeoterm', { clear = true }),
  pattern = '*',
  callback = function()
    vim.opt_local.signcolumn = 'auto'
  end
})

-- Window navigation using reversed-T mapings
vim.keymap.set('t', '<c-h>', '<c-\\><c-n><c-w><c-h>')
vim.keymap.set('t', '<c-t>', '<c-\\><c-n><c-w><c-j>')
vim.keymap.set('t', '<c-n>', '<c-\\><c-n><c-w><c-l>')
vim.keymap.set('t', '<c-c>', '<c-\\><c-n><c-w><c-k>')
