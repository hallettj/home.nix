local from_nixpkgs = require('config.util').from_nixpkgs

-- The main treesitter plugin, 'nvim-treesitter/nvim-treesitter', is installed
-- with nix to get prebuilt grammars. This spec declares extra plugins that
-- layer on top of the base treesitter. The treesitter setup call is in
-- lua/config/treesitter.lua.
return {
  from_nixpkgs { 'nvim-treesitter/nvim-treesitter' },
  {
    'Wansmer/sibling-swap.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    keys = {
      '<C-.>',
      '<C-,>',
      '<leader>.',
      '<leader>,',
    },
    opts = {
      highlight_node_at_cursor = {
        ms = 400, hl_opts = { link = 'IncSearch', },
      },
    },
  },
  { 'nvim-treesitter/nvim-treesitter-textobjects' },
  { 'RRethy/nvim-treesitter-textsubjects' },
  { 'nvim-treesitter/nvim-treesitter-refactor' },

  -- Shows lines with containing function, struct, etc. if that would otherwise
  -- be scrolled off the top of the screen.
  {
    'nvim-treesitter/nvim-treesitter-context',
    opts = {
      max_lines = 4,
    },
  },
}
