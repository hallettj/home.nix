-- @class TSConfig
require('nvim-treesitter.configs').setup {
  highlight = {
    enable = true,
  },
  indent = { enable = true },

  -- 'nvim-treesitter/nvim-treesitter-refactor',
  refactor = {
    highlight_definitions = { enable = true },
    highlight_current_scope = { enable = false },
  },

  -- 'nvim-treesitter/nvim-treesitter-textobjects',
  textobjects = {
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


  -- 'RRethy/nvim-treesitter-textsubjects',
  textsubjects = {
    enable = true,
    -- prev_selection = ',',
    keymaps = {
      ['.'] = 'textsubjects-smart',
      [';'] = 'textsubjects-container-outer',
      ['i;'] = 'textsubjects-container-inner',
    },
  },
}
