{ inputs, ... }:
{
  flake-file.inputs.sibling-swap-nvim = {
    url = "github:Wansmer/sibling-swap.nvim";
    flake = false;
  };

  flake.nvim-config.treesitter =
    { config, pkgs, ... }:
    {
      specs.treesitter = {
        data = pkgs.vimPlugins.nvim-treesitter.withAllGrammars;
        config = /* lua */ ''
          -- Initialize treesitter
          vim.api.nvim_create_autocmd('FileType', {
            callback = function()
              -- Enable treesitter highlighting, and disable regex syntax
              pcall(vim.treesitter.start)
              -- Enable treesitter-based indentation
              vim.bo.indentexpr = "v:lua.require('nvim-treesitter').indentexpr()"
            end,
          })
        '';
      };

      specs.treesitter-textobjects = {
        data = pkgs.vimPlugins.nvim-treesitter-textobjects;
        config = /* lua */ ''
          local move = require 'nvim-treesitter-textobjects.move'
          vim.keymap.set({ 'n', 'x', 'o' }, ']m', function() move.goto_next_start('@function.outer', 'textobjects') end)
          vim.keymap.set({ 'n', 'x', 'o' }, ']]', function() move.goto_next_start('@class.outer', 'textobjects') end)
          vim.keymap.set({ 'n', 'x', 'o' }, ']M', function() move.goto_next_end('@function.outer', 'textobjects') end)
          vim.keymap.set({ 'n', 'x', 'o' }, '][', function() move.goto_next_end('@class.outer', 'textobjects') end)
          vim.keymap.set({ 'n', 'x', 'o' }, '[m', function() move.goto_previous_start('@function.outer', 'textobjects') end)
          vim.keymap.set({ 'n', 'x', 'o' }, '[[', function() move.goto_previous_start('@class.outer', 'textobjects') end)
          vim.keymap.set({ 'n', 'x', 'o' }, '[M', function() move.goto_previous_end('@function.outer', 'textobjects') end)
          vim.keymap.set({ 'n', 'x', 'o' }, '[]', function() move.goto_previous_end('@class.outer', 'textobjects') end)
        '';
      };

      specs.treesitter-context = {
        data = pkgs.vimPlugins.nvim-treesitter-context;
        config = /* lua */ ''
          require('treesitter-context').setup {
            max_lines = 4,
          }
        '';
      };

      specs.sibling-swap = {
        data = config.nvim-lib.mkPlugin "sibling-swap.nvim" inputs.sibling-swap-nvim;
        lazy = true;
        after = [ "lze" ];
        config = /* lua */ ''
          require('lze').load {
            'sibling-swap.nvim',
            keys = { '<C-.>', '<C-,>' },
            after = function()
              require('sibling-swap').setup {
                highlight_node_at_cursor = {
                  ms = 400,
                  hl_opts = { link = 'IncSearch' },
                },
              }
            end,
          }
        '';
      };
    };
}
