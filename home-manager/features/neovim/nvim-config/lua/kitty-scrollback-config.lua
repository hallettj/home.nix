-- Minimal configuration that is loaded instead of my main configuration when invoking kitty-scrollback.nvim

local reduced_plugin_set = {
  'kitty-scrollback.nvim',
  'vim-repeat',
  'leap.nvim',
  'nvim-surround',
  'targets.vim',
  'vim-textobj-user.vim',
  'vim-textobj-entire.vim',
  'vim-textobj-line.vim',
  'vim-niceblock',
}
for _, p in ipairs(reduced_plugin_set) do
  vim.opt.runtimepath:append(vim.fn.stdpath('data') .. '/lazy/' .. p)
end

vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'

local map = vim.keymap.set

-- Swap : and ,
map({ 'n', 'v' }, ',', ':', { desc = 'enter command mode' })
map({ 'n', 'v' }, ':', ',', { desc = 'repeat latest f, t, F, or T in opposite direction' })

-- Swap ' and `
map({ 'n', 'v' }, "'", '`', { desc = 'jump to mark in the current buffer' })
map({ 'n', 'v' }, '`', "'", { desc = 'jump to mark in the current buffer' })

vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('kitty-scrollback-keybinds', { clear = true }),
  pattern = 'kitty-scrollback',
  callback = function(data)
    -- Match some of the keybinds of less
    map('n', 'q', '<Plug>(KsbQuitAll)', { desc = 'quit kitty-scrollback.nvim', buffer = data.buf })
    map('n', 'u', '<C-u>', { desc = 'scroll up half a page', buffer = data.buf })
    map('n', 'd', '<C-d>', { desc = 'scroll down half a page', buffer = data.buf })
  end
})

local leap_config = require('plugins.leap')[1]
leap_config.config()

local surround_config = require('plugins.surround')
require('nvim-surround').setup(surround_config.opts)
surround_config.init()

require('kitty-scrollback').setup {
  -- options here
}
