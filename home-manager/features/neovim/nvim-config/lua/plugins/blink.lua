local from_nixpkgs = require('config.util').from_nixpkgs

return from_nixpkgs {
  'saghen/blink.cmp',
  enabled = require('config.features').blink,

  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    keymap = { preset = 'enter' },
    appearance = {
      -- Sets the fallback highlight groups to nvim-cmp's highlight groups
      -- Useful for when your theme doesn't support blink.cmp
      -- Will be removed in a future release
      use_nvim_cmp_as_default = true,
      -- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
      -- Adjusts spacing to ensure icons are aligned
      nerd_font_variant = 'mono'
    },
    completion = {
      menu = {
        draw = {
          columns = { { 'kind_icon' }, { 'label', 'label_description', gap = 1 }, { 'source_name' } },
        },
      },
      list = {
        selection = {
          preselect = false, -- this setting works better with the 'enter' keymap preset
        },
      },
    },
    cmdline = {
      keymap = { preset = 'inherit' },
      completion = {
        menu = { auto_show = true },
        list = { selection = { preselect = false } },
      },
    },
    sources = {
      default = { 'lsp', 'path', 'snippets', 'buffer' },
    },
  },

  -- Extend default sources list instead of merging if the same setting is
  -- applied elsewhere.
  opts_extend = { 'sources.default' },
}
