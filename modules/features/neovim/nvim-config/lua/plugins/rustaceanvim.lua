return {
  'mrcjkb/rustaceanvim',
  version = '^5',
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
  init = function()
    vim.g.rustaceanvim = {
      server = {
        default_settings = {
          ['rust-analyzer'] = {
            cargo = {
              allFeatures = true
            }
          }
        },
        ---@diagnostic disable-next-line: unused-local
        on_attach = function(client, bufnr)
          -- Modify semantic highlighting to make highlighting for strings
          -- transparent. This prevents semantic highlighting from overriding
          -- highlighting from treesitter language injections, like my
          -- sqlx::query!() injection.
          vim.api.nvim_set_hl(0, "@lsp.type.string.rust", {})
        end,
      }
    }
  end
}
