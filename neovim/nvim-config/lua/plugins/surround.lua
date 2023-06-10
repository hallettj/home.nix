local dict = require 'dict'

-- Customize keymaps to avoid conflicts with leap.
--
-- The general rule is that if the key ends in "_line", the delimiter pair is
-- added on new lines. If the key ends in "_cur", the surround is performed
-- around the current line.
local keymaps = {
  insert          = '<C-g>z',
  insert_line     = '<C-g>Z',
  normal          = 'gz',
  normal_cur      = 'gzz',
  normal_line     = 'gZ',
  normal_cur_line = 'gZZ',
  visual          = 'gz',
  visual_line     = 'gZ',
  delete          = 'dz',
  change          = 'cz',
}

return {
  'kylechui/nvim-surround',
  version = '*', -- Use for stability; omit to use `main` branch for the latest features
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    'nvim-treesitter/nvim-treesitter-textobjects',
  },
  keys = dict.values(keymaps),
  opts = {
    keymaps = keymaps,
    highlight = {
      duration = 150, -- ms
    },
  },
  init = function()
    vim.cmd.highlight({ 'link', 'NvimSurroundHighlight', 'IncSearch' })
  end,
}
