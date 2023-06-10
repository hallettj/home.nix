return {
  'marko-cerovac/material.nvim',
  lazy = true,
  dependencies = { 'nvim-lualine/lualine.nvim' },
  opts = {
    contrast = {
      popup_menu = true,
    },
    contrast_filetypes = {
      'terminal',
      'toggleterm',
    },
    italics = {
      comments = true,
      functions = false,
      keywords = true,
      strings = false,
      variables = false,
    },
    lualine_style = 'default', -- values are "default" or "stealth"
  },
}
