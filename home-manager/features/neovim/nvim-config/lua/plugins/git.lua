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
      vim.api.nvim_create_autocmd('User', {
        group = vim.api.nvim_create_augroup('fugitive-custom-mappings', { clear = true }),
        pattern = 'FugitiveIndex',
        callback = function(opts)
          vim.keymap.set('n', '<right>', '>', { desc = 'show diff under cursor', buffer = opts.buf, remap = true })
          vim.keymap.set('n', '<left>', '<', { desc = 'hide diff under cursor', buffer = opts.buf, remap = true })
          vim.keymap.set('n', '<tab>', '=', { desc = 'toggle diff under cursor', buffer = opts.buf, remap = true })
        end,
      })

      -- Load rhubarb whenever fugitive is loaded
      vim.cmd [[Lazy load vim-rhubarb]]
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
    dependencies = { 'tpope/vim-fugitive' },
    cmd = 'GV',
    keys = {
      { '<leader>gl', '<cmd>GV<cr>',       desc = 'log graph for branch' },
      { '<leader>gL', '<cmd>GV --all<cr>', desc = 'log graph for all branches' },
    },
  },

  {
    'sindrets/diffview.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = { use_icons = true },
    lazy = true,
  },
}
