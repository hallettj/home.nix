return {
  'echasnovski/mini.nvim',
  version = false,
  config = function()
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
