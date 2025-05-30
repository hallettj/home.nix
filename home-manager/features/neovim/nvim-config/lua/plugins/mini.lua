return {
  'echasnovski/mini.nvim',
  dependencies = {
    'nvim-treesitter/nvim-treesitter-textobjects',
  },
  version = false,
  config = function()
    local treesitter = require('mini.ai').gen_spec.treesitter
    require('mini.ai').setup {
      -- Some of these captures use custom queries defined in this repo in
      -- `after/queries/<language>/textobjects.scm`
      custom_textobjects = {
        a = treesitter { a = '@parameter.outer', i = '@parameter.inner' },
        B = treesitter { a = '@block.outer', i = '@block.inner' },
        c = treesitter { a = '@comment.outer', i = '@comment.inner' }, -- only 'ac' works in Rust
        d = treesitter { a = '@class.outer', i = '@class.inner' },     -- 'd' for "declaration"
        f = treesitter { a = '@call.outer', i = '@call.inner' },
        i = treesitter { a = '@import.outer', i = '@import.inner' },
        t = treesitter { a = '@custom_capture.outer', i = '@custom_capture.inner' }, -- 'd' for "declaration"
        m = treesitter { a = '@function.outer', i = '@function.inner' },             -- 'm' for "method"
        o = treesitter {
          a = { '@conditional.outer', '@loop.outer' },
          i = { '@conditional.inner', '@loop.inner' },
        },
        R = treesitter { a = '@return.outer', i = '@return.inner' },
        s = treesitter { a = '@statement.outer', i = '@statement.inner' },   -- only 'as' works in Rust
        v = treesitter { a = '@assignment.outer', i = '@assignment.inner' }, -- 'v' for "variable declaration"; inner gets lhs or rhs depending on cursor position
      },
    }

    -- To align a markdown table select the table, then type gA|<cr>
    require('mini.align').setup {
      -- Module mappings. Use `''` (empty string) to disable one.
      mappings = {
        start = '', -- default mapping, ga, conflicts with character info binding
        start_with_preview = 'gA',
      },
    }

    require('mini.operators').setup {
      -- Evaluate text and replace with output
      evaluate = {
        prefix = 'g=',
      },

      -- Exchange text regions
      exchange = {
        prefix = 'g>', -- changed from `gx` to avoid conflict with built-in mapping
        reindent_linewise = true,
      },

      -- Multiply (duplicate) text
      multiply = {
        prefix = 'gm',
      },

      -- Replace text with register
      replace = {
        prefix = 'gp', -- changed from `gr` because I use that for "find references"
        reindent_linewise = true,
      },

      -- Sort text
      sort = {
        prefix = 'gs',
      }
    }
  end
}
