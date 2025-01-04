-- nvim-dap is a debugging protocol to connect nvim to various debuggers
return {
  {
    'mfussenegger/nvim-dap',
    keys = {
      { '<leader>dl', function() require('dap.ui.widgets').hover() end,  desc = 'dap: show hover info' },
      { '<leader>dc', function() require('dap').continue() end,          desc = 'dap: continue execution' },
      { '<leader>db', function() require('dap').toggle_breakpoint() end, desc = 'toggle breakpoint' },
      { '<leader>dn', function() require('dap').step_over() end,         desc = 'dap: step over' },
      { '<leader>di', function() require('dap').step_into() end,         desc = 'dap: step into' },
      { '<leader>do', function() require('dap').step_out() end,          desc = 'dap: step out' },
      {
        '<leader>dC',
        function()
          require('dap').clear_breakpoints()
          vim.notify('breakpoints cleared', vim.log.levels.WARN)
        end,
        desc = 'dap: clear breakpoints'
      },
    },
  },
  {
    'theHamsta/nvim-dap-virtual-text',
    dependencies = {
      'mfussenegger/nvim-dap',
    },
    opts = {},
  },
  {
    'rcarriga/nvim-dap-ui',
    dependencies = {
      'mfussenegger/nvim-dap',
    },
    opts = {},
    keys = {
      { '<leader>ds', function() require('dapui').toggle({}) end, desc = 'start debugging session' },
      {
        '<leader>de',
        function()
          local dap = require('dap')
          dap.clear_breakpoints()
          require('dapui').close()
          dap.terminate()
          vim.notify('debugger session ended', vim.log.levels.WARN)
        end,
        desc = 'close debugger and clear breakpoints'
      }
    },
  },
}
