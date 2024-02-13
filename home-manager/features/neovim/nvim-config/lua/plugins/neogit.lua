return {
  'NeogitOrg/neogit',
  branch = 'nightly', -- to match nightly nvim
  dependencies = {
    'nvim-lua/plenary.nvim',
    'sindrets/diffview.nvim',
    'nvim-telescope/telescope.nvim',
  },
  keys = {
    { '<leader>gs', function() require('neogit').open({ cwd = vim.fn.expand('%:p:h') }) end, desc = 'git status' }
  },
  config = function()
    require('neogit').setup {
      disable_hint = true,
      graph_style = 'unicode',
      kind = 'auto',
      commit_editor = {
        kind = 'split',
      },
      mappings = {
        status = {
          ['='] = 'Stage',
          ['+'] = 'StageUnstaged',
          ['-'] = 'Unstage',
          ['_'] = 'UnstageStaged',

          -- reserve these keys for leap
          ['s'] = false,
          ['S'] = false,
        },
      },
    }
  end,
}
