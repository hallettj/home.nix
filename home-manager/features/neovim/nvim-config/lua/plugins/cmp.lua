-- Autocompletion
return {
  'hrsh7th/nvim-cmp',
  dependencies = {
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-cmdline',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-nvim-lua',

    -- cmp must be configured with a snippet engine
    'L3MON4D3/LuaSnip',
    'saadparwaiz1/cmp_luasnip',

    'zbirenbaum/copilot-cmp',
  },
  config = function()
    local cmp = require('cmp')

    cmp.setup {
      snippet = {
        expand = function(args)
          require('luasnip').lsp_expand(args.body)
        end,
      },
      mapping = cmp.mapping.preset.insert {
        -- -- `Enter` key to confirm completion
        ['<CR>'] = cmp.mapping.confirm({ select = false }),
        ['<C-Space>'] = cmp.mapping.complete(),
      },
      sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'luasnip', keyword_length = 2 },
        { name = 'copilot' },
        { name = 'path' },
        { name = 'buffer',  keyword_length = 3 },
      }),
    }

    -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
    cmp.setup.cmdline({ '/', '?' }, {
      mapping = cmp.mapping.preset.cmdline(),
      sources = {
        { name = 'buffer' }
      }
    })

    -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
    cmp.setup.cmdline(':', {
      mapping = cmp.mapping.preset.cmdline {
        ['<Down>'] = { c = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }) },
        ['<Up>'] = { c = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }) },
      },
      sources = cmp.config.sources({
        { name = 'path' }
      }, {
        { name = 'cmdline' }
      })
    })
  end,
}
