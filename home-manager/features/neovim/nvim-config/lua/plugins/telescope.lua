return {
  {
    'nvim-telescope/telescope.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
      'folke/trouble.nvim',
      'nvim-tree/nvim-web-devicons',
    },
    keys = {
      { '<leader>b',  function() require('telescope.builtin').buffers() end,               desc = 'find a buffer' },
      { '<leader>fg', function() require('telescope.builtin').live_grep() end,             desc = 'live grep' },
      { '<leader>fh', function() require('telescope.builtin').help_tags() end,             desc = 'search help tags' },
      { '<leader>fC', function() require('telescope.builtin').colorscheme() end,           desc = 'pick color scheme' },
      { '<leader>fr', function() require('telescope.builtin').resume() end,                desc = 'resume last search' },
      { '<leader>fs', function() require('telescope.builtin').lsp_document_symbols() end,  desc = 'search document symbols' },
      { '<leader>fS', function() require('telescope.builtin').lsp_workspace_symbols() end, desc = 'search workspace symbols' },
    },
    config = function()
      local telescope = require('telescope')

      local open_with_trouble = require('trouble.sources.telescope').open

      telescope.setup {
        defaults = {
          mappings = {
            i = { ['<c-t>'] = open_with_trouble },
            n = { ['<c-t>'] = open_with_trouble },
          },
        },
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
      telescope.load_extension('fzf')
    end,
  },

  {
    'danielfalk/smart-open.nvim',
    branch = '0.2.x',
    dependencies = {
      'nvim-telescope/telescope.nvim',
      'nvim-telescope/telescope-fzy-native.nvim',
      'nvim-tree/nvim-web-devicons',
      {
        'kkharji/sqlite.lua',
        init = function()
          -- This environment variable is set in neovim/default.nix
          vim.g.sqlite_clib_path = os.getenv('SQLITE_CLIB_PATH')
        end
      },
    },
    keys = {
      { '<C-p>', function() require('telescope').extensions.smart_open.smart_open() end, desc = 'find file using smart-open' },
    },
    config = function()
      require('telescope').load_extension('smart_open')
    end,
  },

  -- Navigate to previously-accessed directory
  {
    'jvgrootveld/telescope-zoxide',
    dependencies = {
      'nvim-lua/popup.nvim',
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope.nvim'
    },
    keys = {
      {
        '<c-g>',
        function() require('telescope').extensions.zoxide.list() end,
        mode = 'n',
        desc = 'cd to a project',
      },
    },
    config = function()
      local t = require('telescope')

      -- Configure the extension
      t.setup({
        extensions = {
          zoxide = {},
        },
      })

      -- Load the extension
      t.load_extension('zoxide')
    end
  },
}
