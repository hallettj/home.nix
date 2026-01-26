-- nvim-dap is a debugging protocol to connect nvim to various debuggers
return {
  'mfussenegger/nvim-dap',
  keys = {
    { '<leader>dl', function() require('dap.ui.widgets').hover() end,          desc = 'dap: show hover info' },
    { '<leader>dc', function() require('dap').continue() end,                  desc = 'dap: continue execution' },
    { '<leader>db', function() require('dap').toggle_breakpoint() end,         desc = 'toggle breakpoint' },
    { '<leader>dn', function() require('dap').step_over() end,                 desc = 'dap: step over' },
    { '<leader>di', function() require('dap').step_into() end,                 desc = 'dap: step into' },
    { '<leader>do', function() require('dap').step_out() end,                  desc = 'dap: step out' },
    { '<leader>rc', function() require('dap').run_to_cursor() end,             desc = 'dap: run to cursor' },
    { '<leader>?',  function() require('dap').eval(nil, { enter = true }) end, desc = 'eval var under cursor' },
    {
      '<leader>dC',
      function()
        require('dap').clear_breakpoints()
        vim.notify('breakpoints cleared', vim.log.levels.WARN)
      end,
      desc = 'dap: clear breakpoints'
    },
  },
  dependencies = {
    {
      'theHamsta/nvim-dap-virtual-text',
      dependencies = { 'nvim-treesitter/nvim-treesitter' },
      opts = {},
    },
    {
      'rcarriga/nvim-dap-ui',
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
      dependencies = { 'nvim-neotest/nvim-nio' },
      opts = {},
    }
  },
  config = function()
    local dap = require('dap')
    local ui = require('dapui')

    -- automatically open dap-ui
    dap.listeners.before.attach.dapui_config = function() ui.open() end
    dap.listeners.before.launch.dapui_config = function() ui.open() end
    dap.listeners.before.event_terminated.dapui_config = function() ui.close() end
    dap.listeners.before.event_exited.dapui_config = function() ui.close() end
  end,
}
