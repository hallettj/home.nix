-- The plugins listed here are those without substantial configuration
-- requirements. There are more plugins declared in other modules in this
-- directory.
return {
  'tpope/vim-sensible',
  'tpope/vim-sleuth',

  -- Automatically load environment variables set in a `.envrc` or `.env` file
  -- when changing to a directory with such a file.
  'direnv/direnv.vim',

  -- Navigation
  { 'simnalamburt/vim-mundo', cmd = 'MundoToggle' }, -- UI for navigating undo history
  { 'sindrets/winshift.nvim', config = true },

  -- Show input prompts in floating window; make selections with Telescope
  { 'stevearc/dressing.nvim', event = 'VeryLazy', config = true },

  'tpope/vim-unimpaired', -- shortcuts for cycling/toggling different things
  'tpope/vim-characterize', -- show information about character under cursor
  'tpope/vim-repeat', -- makes the `.` command work with third-party actions
  'tpope/vim-rsi', -- add Emacs-like shortcuts to command mode

  -- Text objects
  { 'kana/vim-textobj-entire', dependencies = { 'kana/vim-textobj-user' } }, -- `ae`: entire buffer, `ie`: excludes empty lines
  { 'kana/vim-textobj-line', dependencies = { 'kana/vim-textobj-user' } }, -- `al`: entire line, `il` excludes whitespace

  -- more from kana
  'kana/vim-niceblock', -- makes `I` and `A` work in line-wise visual mode

  -- Language support
  { 'DeltaWhy/vim-mcfunction', ft = 'mcfunction' },
  { 'vmchale/dhall-vim', ft = 'dhall' },
  'xasopheno/weresocool_vim',
}
