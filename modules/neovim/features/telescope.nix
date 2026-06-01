{
  flake.nvim-config.telescope =
    { pkgs, ... }:
    {
      specs.telescope = {
        data = with pkgs.vimPlugins; [
          telescope-fzf-native-nvim
          telescope-nvim
        ];
        name = "telescope";
        after = [ "lze" ];
        config = /* lua */ ''
          require('lze').load {
            'telescope.nvim',
            keys = {
              { '<leader>b', function() require('telescope.builtin').buffers() end, desc = 'find a buffer' },
              { '<leader>fg', function() require('telescope.builtin').live_grep() end, desc = 'live grep' },
              { '<leader>fh', function() require('telescope.builtin').help_tags() end, desc = 'search help tags' },
              { '<leader>fC', function() require('telescope.builtin').colorscheme() end, desc = 'pick color scheme' },
              { '<leader>fr', function() require('telescope.builtin').resume() end, desc = 'resume last search' },
              {
                '<leader>fs',
                function() require('telescope.builtin').lsp_document_symbols() end,
                desc = 'search document symbols',
              },
              {
                '<leader>fS',
                function() require('telescope.builtin').lsp_workspace_symbols() end,
                desc = 'search workspace symbols',
              },
            },
            after = function()
              local telescope = require 'telescope'
              local open_with_trouble = require('trouble.sources.telescope').open

              telescope.setup {
                defaults = {
                  mappings = {
                    i = { ['<c-t>'] = open_with_trouble },
                    n = { ['<c-t>'] = open_with_trouble },
                  },
                },
              }
              telescope.load_extension 'fzf'
            end,
          }
        '';
      };

      # open files, with some intelligence to surface files you're more likely to want to access
      specs.smart-open = {
        data = with pkgs.vimPlugins; [
          nvim-web-devicons
          smart-open-nvim
        ];
        lazy = true;
        after = [ "lze" ];
        config = /* lua */ ''
          require('lze').load {
            'smart-open.nvim',
            keys = {
              {
                '<C-p>',
                function() require('telescope').extensions.smart_open.smart_open() end,
                desc = 'find file using smart-open',
              },
            },
            after = function()
              local t = require 'telescope'

              t.setup {
                extensions = {
                  smart_open = {
                    ignore_patterns = {
                      '*.git/*',
                      '*/tmp/*',
                      '*/target/*',
                    },
                  },
                },
              }

              require('telescope').load_extension 'smart_open'
            end,
          }
        '';
      };

      runtimePkgs = with pkgs; [
        fd # used by telescope's find_files builtin, which I'm not actually using right now
        ripgrep # used by smart-open
      ];

      # navigate to previously-accessed directories using zoxide's frecency heuristics
      specs.telescope-zoxide = {
        data = with pkgs.vimPlugins; [
          popup-nvim
          telescope-zoxide
        ];
        lazy = true;
        after = [ "lze" ];
        config = /* lua */ ''
          require('lze').load {
            'telescope-zoxide',
            keys = {
              { '<c-g>', function() require('telescope').extensions.zoxide.list() end, desc = 'cd to a project' },
            },
            after = function()
              local t = require 'telescope'

              -- Configure the extension
              t.setup { extensions = { zoxide = {} } }

              -- Load the extension
              t.load_extension 'zoxide'
            end,
          }
        '';
      };
    };
}
