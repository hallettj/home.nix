{
  flake.nvim-config.rust =
    { pkgs, ... }:
    {
      specs.rustaceanvim = {
        data = pkgs.vimPlugins.rustaceanvim;
        after = [ "lze" ];
        config = /* lua */ ''
          require('lze').load {
            'rustaceanvim',
            keys = {
              {
                '<leader>cc',
                ft = 'rust',
                function() vim.cmd.RustLsp 'codeAction' end,
                desc = 'code actions at cursor or selection',
                mode = { 'n', 'x' },
                silent = true,
              },

              {
                '<leader>dd',
                ft = 'rust',
                function() vim.cmd.RustLsp 'debug' end,
                desc = 'debug target at cursor',
              },
              {
                '<leader>D',
                ft = 'rust',
                function() vim.cmd.RustLsp { 'debuggables', bang = true } end,
                desc = 'debug last target again',
              },

              {
                '<leader>ld',
                ft = 'rust',
                function() vim.cmd.RustLsp 'debuggables' end,
                desc = 'list debuggables',
              },
              {
                '<leader>lr',
                ft = 'rust',
                function() vim.cmd.RustLsp 'runnables' end,
                desc = 'list runnables',
              },

              {
                '<leader>rr',
                ft = 'rust',
                function() vim.cmd.RustLsp 'run' end,
                desc = 'run target at cursor',
              },
              {
                '<leader>R',
                ft = 'rust',
                function() vim.cmd.RustLsp { 'run', bang = true } end,
                desc = 'run last target again',
              },

              {
                'gC',
                ft = 'rust',
                function() vim.cmd.RustLsp 'openCargo' end,
                desc = 'open Cargo.toml',
              },
            },
          }

          vim.g.rustaceanvim = { server = { default_settings = { ['rust-analyzer'] = { cargo = { allFeatures = true } } } } }
        '';
      };

      runtimePkgs = with pkgs; [
        lldb # debug adapter
        graphviz # to render crate graphs from rustaceanvim
        vscode-extensions.vadimcn.vscode-lldb.adapter # Provides codelldb which rustaceanvim uses for debugging Rust targets

        python312Packages.pylatexenc # to get latex2text for render-markdown
      ];

      # Editor support for managing Rust crates. In `Cargo.toml` you will see virtual
      # text showing the installed version for each dependency, and options for
      # upgrading.
      #
      # Type `K` over a crate name, version number, or feature for an info popup.
      # Press `K` again to focus the popup. Highlight version numbers or features and
      # press `<cr>` to apply or to unapply.
      #
      # To install a new dependency type it out, and when you get to the version
      # field press `<tab>` inside an empty set of quotes to see available versions.
      specs.crates = {
        data = pkgs.vimPlugins.crates-nvim;
        config = /* lua */ ''
          local crates = require 'crates'

          crates.setup {
            lsp = {
              enabled = true,
              actions = true,
              completion = true,
              hover = true,
            },
          }

          vim.api.nvim_create_autocmd('BufRead', {
            group = vim.api.nvim_create_augroup('CratesNvimCustomization', { clear = true }),
            pattern = 'Cargo.toml',
            callback = function(data)
              local opts = { buffer = data.buf, silent = true }
              local function map(mode, lhs, rhs, desc)
                vim.keymap.set(mode, lhs, rhs, vim.tbl_extend('force', opts, { desc = desc }))
              end

              require('which-key').add { { '<leader>C', group = '+crates.nvim', buffer = data.buf } }
              map('n', '<leader>Ct', crates.toggle, 'toggle')
              map('n', '<leader>Cr', crates.reload, 'reload')
              map('n', '<leader>Cv', crates.show_versions_popup, 'show versions')
              map('n', '<leader>Cf', crates.show_features_popup, 'show features')
              map('n', '<leader>Cd', crates.show_dependencies_popup, 'show dependencies')
              map('n', '<leader>Cu', crates.update_crate, 'update crate')
              map('n', '<leader>Ca', crates.update_all_crates, 'update all crates')
              map('n', '<leader>CU', crates.upgrade_crate, 'upgrade crate')
              map('n', '<leader>CA', crates.upgrade_all_crates, 'upgrade all crates')
              map('n', '<leader>CH', crates.open_homepage, 'open homepage')
              map('n', '<leader>CR', crates.open_repository, 'open repository')
              map('n', '<leader>CD', crates.open_documentation, 'open documentation')
              map('n', '<leader>CC', crates.open_crates_io, 'open crates.io')
              map('v', '<leader>Cu', crates.update_crates, 'update crates')
              map('v', '<leader>CU', crates.upgrade_crates, 'upgrade crates')
              map('n', 'K', function()
                if crates.popup_available() then
                  crates.show_popup()
                else
                  vim.lsp.buf.hover()
                end
              end, 'hover documentation')
            end,
          })
        '';
      };
    };
}
