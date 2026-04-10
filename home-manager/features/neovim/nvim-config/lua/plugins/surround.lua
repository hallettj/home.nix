local dict = require 'dict'

local keymaps = {
  normal          = 'gz',
  normal_cur      = 'gzz',
  normal_line     = 'gZ',
  normal_cur_line = 'gZZ',
  visual          = 'gz',
  visual_line     = 'gZ',
  delete          = 'dz',
  change          = 'cz',
}

return {
  'kylechui/nvim-surround',
  version = '*', -- Use for stability; omit to use `main` branch for the latest features
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    'nvim-treesitter/nvim-treesitter-textobjects',
  },
  -- Customize keymaps to avoid conflicts with leap.
  keys = {
    { '<C-g>s', mode = { 'i' }, '<Plug>(nvim-surround-insert)',          desc = 'add delimiters arround cursor' },
    { '<C-g>S', mode = { 'i' }, '<Plug>(nvim-surround-insert-line)',     desc = 'add delimiters arround cursor, on new lines' },
    { 'gz',     mode = { 'n' }, '<Plug>(nvim-surround-normal)',          desc = 'add delimiters around a motion' },
    { 'gzz',    mode = { 'n' }, '<Plug>(nvim-surround-normal-cur)',      desc = 'add delimiters around current line' },
    { 'gZ',     mode = { 'n' }, '<Plug>(nvim-surround-normal-line)',     desc = 'add delimiters around a motion, on new lines' },
    { 'gZZ',    mode = { 'n' }, '<Plug>(nvim-surround-normal-cur-line)', desc = 'add delimiters around current line, on new lines' },
    { 'gz',     mode = { 'x' }, '<Plug>(nvim-surround-visual)',          desc = 'add delimiters arround selection' },
    { 'gZ',     mode = { 'x' }, '<Plug>(nvim-surround-visual-line)',     desc = 'add delimiters arround selection, on new lines' },
    { 'dz',     mode = { 'n' }, '<Plug>(nvim-surround-delete)',          desc = 'delete specified delimiters' },
    { 'cz',     mode = { 'n' }, '<Plug>(nvim-surround-change)',          desc = 'change specified delimeters' },
    { 'cZ',     mode = { 'n' }, '<Plug>(nvim-surround-change-line)',     desc = 'change change specified delimiters, putting replacements on new lines' },
  },
  opts = {
    highlight = {
      duration = 150, -- ms
    },
  },
  init = function()
    vim.g.nvim_surround_no_mappings = true -- disable default bindings
    vim.cmd.highlight({ 'link', 'NvimSurroundHighlight', 'IncSearch' })
  end,
}
