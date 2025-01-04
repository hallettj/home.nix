return {
  'nvim-neotest/neotest',
  dependencies = {
    'nvim-neotest/nvim-nio',
    'nvim-lua/plenary.nvim',
    -- 'antionemadec/FixCursorHold.nvim',
    'nvim-treesitter/nvim-treesitter',

    -- test adapters
    'mrcjkb/rustaceanvim',
  },
  keys = {
    { '<leader>tt', mode = 'n', function() require('neotest').run.run() end,  desc = 'run the nearest test' },
    { '<leader>t%', mode = 'n', function() require('neotest').run.run(vim.fn.expand('%')) end,  desc = 'run all tests in current file' },
    { '<leader>tS', mode = 'n', function() require('neotest').run.stop() end, desc = 'stop the nearest test' },
    { '<leader>ta', mode = 'n', function() require('neotest').run.stop() end, desc = 'attach to the nearest test' },
    { '<leader>to', mode = 'n', function() require('neotest').output.open() end, desc = 'show test output' },
    { '<leader>tp', mode = 'n', function() require('neotest').output_panel.toggle() end, desc = 'toggle test panel' },
    { '<leader>ts', mode = 'n', function() require('neotest').summary.toggle() end, desc = 'toggle test summary sidebar' },
    { '<leader>tw', mode = 'n', function() require('neotest').watch.toggle() end, desc = 'start/stop watching test' },
  },
  config = function()
    require('neotest').setup {
      adapters = {
        require('rustaceanvim.neotest')
      }
    }
  end
}
