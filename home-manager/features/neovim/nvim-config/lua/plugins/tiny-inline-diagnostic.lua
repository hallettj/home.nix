return {
  'rachartier/tiny-inline-diagnostic.nvim',
  event = 'VeryLazy',
  config = function()
    require('tiny-inline-diagnostic').setup {
      options = {
        show_source = {
          enabled = false,
          if_many = false,
        },
        multilines = {
          enabled = true, -- show diagnostics on multiple source lines unless cursor is on one of those lines
        },
      },
    }
    vim.diagnostic.config { virtual_text = false } -- tiny handles virtual text
  end
}
