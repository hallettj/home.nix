-- local features = require('config.features')

return {
  'folke/lazydev.nvim',
  ft = 'lua', -- only load on lua files
  opts = {
    library = {
      -- See the configuration section for more details
      -- Load luvit types when the `vim.uv` word is found
      { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
    },
  },
  dependencies = {
    { -- optional blink completion source for require statements and module annotations
      'saghen/blink.cmp',
      optional = true,
      opts = {
        sources = {
          default = { 'lazydev' },
          providers = {
            lazydev = {
              name = 'LazyDev',
              module = 'lazydev.integrations.blink',
              -- make lazydev completions top priority (see `:h blink.cmp`)
              score_offset = 100,
            },
          },
        },
      },
    }
  },
}
-- make sure to uninstall or disable neodev.nvim
