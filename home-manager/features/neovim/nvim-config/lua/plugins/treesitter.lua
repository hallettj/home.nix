return {
  {
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      { 'IndianBoy42/tree-sitter-just', opts = {} }
    },
    build = ':TSUpdate',
    config = function()
      -- Install uiua grammar
      local parser_config = require('nvim-treesitter.parsers').get_parser_configs()
      parser_config.uiua = {
        install_info = {
          url = 'https://github.com/shnarazk/tree-sitter-uiua.git',
          branch = 'main',
          -- url = '~/projects/vim/tree-sitter-uiua',
          files = { 'src/parser.c' },
        },
      }

      require('nvim-treesitter.configs').setup {
        ensure_installed = 'all',   -- "all", or list of languages
        ignore_install = { 't32' }, -- t32 is failing to download for me
        highlight = {
          enable = true,            -- false will disable the whole extension
          disable = {
            'markdown'
          }, -- list of languages that will be disabled
        },
        indent = { enable = true },
      }
    end,
  },
  {
    'RRethy/nvim-treesitter-textsubjects',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    config = function()
      require('nvim-treesitter.configs').setup {
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
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    config = function()
      require('nvim-treesitter.configs').setup {
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
      }
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter-refactor',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    config = function()
      require('nvim-treesitter.configs').setup {
        refactor = {
          highlight_definitions = { enable = true },
          highlight_current_scope = { enable = false },
        },
      }
    end,
  },
  -- Shows lines with containing function, struct, etc. if that would otherwise
  -- be scrolled off the top of the screen.
  {
    'nvim-treesitter/nvim-treesitter-context',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    opts = {
      max_lines = 4,
    },
  },
}
