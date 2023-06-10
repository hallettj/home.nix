local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-- Bootstrap the lazy.nvim plugin manager
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Set <leader> to <space>. Leader and local leader must be set before
-- initializing plugins.
vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'

-- Initialize plugins, evaluating all modules in `lua/plugins/`
require('lazy').setup('plugins', {
  change_detection = { notify = false },
  dev = { path = '~/projects/vim/' },
})

local opt = vim.opt

opt.encoding = 'utf-8'
opt.scrolloff = 3
opt.wildmode = 'longest'
if vim.fn.has('ttyfast') == 1 then
  opt.ttyfast = true
end

-- Make searches case-sensitive only when capital letters are included.
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = false

-- Wrap long lines
opt.wrap = true
opt.textwidth = 80
opt.formatoptions = { c = true, q = true, r = true, n = true, ['1'] = true }

-- Reverse chirality of splits
opt.splitbelow = true
opt.splitright = true

-- When editing a file, always jump to the last cursor position
autocmd('BufReadPost', {
  group = augroup('restore-cursor-position', { clear = true }),
  pattern = '*',
  callback = function(opts)
    local last_position = vim.api.nvim_buf_get_mark(opts.buf, '"')
    local line, _ = unpack(last_position)
    local total_lines = vim.api.nvim_buf_line_count(opts.buf)
    if line ~= 0 and line <= total_lines and vim.bo.filetype ~= 'gitcommit' then
      vim.api.nvim_feedkeys([[g`"]], 'nx', false)
    end
  end
})

-- Visuals --

opt.signcolumn = 'yes'
opt.showcmd = false
opt.foldenable = false

opt.listchars = { tab = '▸ ', trail = '·' }
opt.conceallevel = 0
opt.concealcursor = 'c'

-- Nicer diffs
opt.diffopt = { 'filler', 'internal', 'algorithm:histogram', 'indent-heuristic' }

autocmd('TextYankPost', {
  group = augroup('highlight-yanked-text', { clear = true }),
  callback = function()
    pcall(vim.highlight.on_yank, { higroup = 'IncSearch', timeout = 400 })
  end,
})

-- Load configuration modules from ~/.config/nvim/lua/init_d/*.lua
require('init_d')
