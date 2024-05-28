return {
  'mrcjkb/rustaceanvim',
  version = '^4',
  lazy = false,
  keys = {
    { '<leader>cc', ft = 'rust', function() vim.cmd.RustLsp('codeAction') end,                  desc = 'code actions at cursor or selection', mode = { 'n', 'x' }, silent = true },

    { '<leader>dd', ft = 'rust', function() vim.cmd.RustLsp('debug') end,                       desc = 'debug target at cursor' },
    { '<leader>D',  ft = 'rust', function() vim.cmd.RustLsp { 'debuggables', bang = true } end, desc = 'debug last target again' },

    { '<leader>ld', ft = 'rust', function() vim.cmd.RustLsp('debuggables') end,                 desc = 'list debuggables' },
    { '<leader>lr', ft = 'rust', function() vim.cmd.RustLsp('runnables') end,                   desc = 'list runnables' },

    { '<leader>rr', ft = 'rust', function() vim.cmd.RustLsp('run') end,                         desc = 'run target at cursor' },
    { '<leader>R',  ft = 'rust', function() vim.cmd.RustLsp { 'run', bang = true } end,         desc = 'run last target again' },

    { 'gC',         ft = 'rust', function() vim.cmd.RustLsp('openCargo') end,                   desc = 'open Cargo.toml' },
  },
}
