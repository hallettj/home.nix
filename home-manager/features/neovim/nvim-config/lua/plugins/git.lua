return {
  {
    'tpope/vim-fugitive',
    cmd = {
      'Git',
      'Gedit', 'Gread', 'Gwrite', 'GRename', 'GMove', 'GRemove', 'GDelete', 'Ggrep', 'GBrowse',
      'Gsplit', 'Gvsplit',
      'Gdiffsplit', 'Ghdiffsplit', 'Gvdiffsplit'
    },
    keys = {
      { '<leader>gs', '<cmd>vert Git<cr>',     desc = 'git status' },
      { '<leader>gc', '<cmd>Git commit<cr>',   desc = 'git commit' },
      { '<leader>gd', '<cmd>Gvdiffsplit<cr>',  desc = 'git diff current file' },
      { '<leader>gD', ':vert Git diff<space>', desc = 'git diff prompting for refs' },
      { '<leader>gb', '<cmd>Git blame<cr>',    desc = 'git blame' },
      { '<leader>ge', ':Gedit<space>',         desc = 'open file from history, e.g. :Gedit HEAD^:%' },
      { '<leader>gp', '<cmd> Git push<cr>',    desc = 'git push' },
      { '<leader>gr', ':GRename<space>',       desc = 'rename file - enter path relative to current file' },
      { '<leader>gR', '<cmd>GDelete<CR>',      desc = 'git rm current file and delete buffer' },

      -- See gitsigns bindings in config/gitsigns.lua for:
      -- - <leader>h
      -- - <leader>tb, <leader>td
      -- - ]c, [c
      -- - ih
    },
    config = function()
      vim.cmd [[Lazy load vim-rhubarb]]
    end,
    init = function()
      -- Shortcuts for git operations to match some of the shell aliases I have.
      -- For example, `:sw ` expands to `:Git switch `
      vim.cmd 'cnoreabbrev sw Git switch'
      vim.cmd 'cnoreabbrev ci Git commit'
      vim.cmd 'cnoreabbrev pull Git pull'
      vim.cmd 'cnoreabbrev push Git push'
      vim.cmd 'cnoreabbrev show Git show'
      vim.cmd 'cnoreabbrev re Git restore'
    end,
  },

  -- Adds autocompletion in fugitive's commit editor for stuff like Github PRs,
  -- and supports :GBrowse in Github repos.
  {
    'tpope/vim-rhubarb',
    dependencies = { 'tpope/vim-fugitive' },
    lazy = true, -- loaded when fugitive loads
  },

  -- Got log viewer
  {
    'junegunn/gv.vim',
    cmd = 'GV',
    keys = {
      { '<leader>gl', '<cmd>GV<cr>',       desc = 'log graph for branch' },
      { '<leader>gL', '<cmd>GV --all<cr>', desc = 'log graph for all branches' },
    },
    init = function()
      vim.cmd 'cnoreabbrev lg GV'
    end,
  },

  {
    'sindrets/diffview.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = { use_icons = true },
    lazy = true,
  },
}
