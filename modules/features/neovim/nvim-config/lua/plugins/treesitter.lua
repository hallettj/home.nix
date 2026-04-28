local from_nixpkgs = require('config.util').from_nixpkgs

-- The main treesitter plugin, 'nvim-treesitter/nvim-treesitter', is installed
-- with nix to get prebuilt grammars, and to get a version of the plugin that is
-- compatible with the version of neovim from nixpkgs.
return {
  from_nixpkgs {
    'nvim-treesitter/nvim-treesitter',
    init = function()
      -- Initialize treesitter
      vim.api.nvim_create_autocmd('FileType', {
        callback = function()
          -- Enable treesitter highlighting, and disable regex syntax
          pcall(vim.treesitter.start)
          -- Enable treesitter-based indentation
          vim.bo.indentexpr = "v:lua.require('nvim-treesitter').indentexpr()"
        end,
      })
    end,
  },

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

  from_nixpkgs {
    'nvim-treesitter/nvim-treesitter-textobjects',
    opts = {
      move = {
        enable = true,
        goto_next_start = {
          [']m'] = '@function.outer',
          [']]'] = '@class.outer',
        },
        goto_next_end = {
          [']M'] = '@function.outer',
          [']['] = '@class.outer',
        },
        goto_previous_start = {
          ['[m'] = '@function.outer',
          ['[['] = '@class.outer',
        },
        goto_previous_end = {
          ['[M'] = '@function.outer',
          ['[]'] = '@class.outer',
        },
      },
    },
  },

  -- {
  --   'RRethy/nvim-treesitter-textsubjects',
  --   opts = {
  --     enable = true,
  --     -- prev_selection = ',',
  --     keymaps = {
  --       ['.'] = 'textsubjects-smart',
  --       [';'] = 'textsubjects-container-outer',
  --       ['i;'] = 'textsubjects-container-inner',
  --     },
  --   },
  -- },

  -- Shows lines with containing function, struct, etc. if that would otherwise
  -- be scrolled off the top of the screen.
  from_nixpkgs {
    'nvim-treesitter/nvim-treesitter-context',
    opts = {
      max_lines = 4,
    },
  },
}
