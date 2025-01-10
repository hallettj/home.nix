local from_nixpkgs = require('config.util').from_nixpkgs

return from_nixpkgs {
  'yetone/avante.nvim',
  enabled = require('config.features').avante,
  event = 'VeryLazy',
  dependencies = {
    'stevearc/dressing.nvim',
    'nvim-lua/plenary.nvim',
    'MunifTanjim/nui.nvim',
    --- The below dependencies are optional,
    require('config.features').nvim_cmp and { 'hrsh7th/nvim-cmp' } or {}, -- autocompletion for avante commands and mentions
    {
      -- support for image pasting
      'HakonHarnes/img-clip.nvim',
      event = 'VeryLazy',
      opts = {
        -- recommended settings
        default = {
          embed_image_as_base64 = false,
          prompt_for_file_name = false,
          drag_and_drop = {
            insert_mode = true,
          },
          -- required for Windows users
          use_absolute_path = true,
        },
      },
    },
  },
  opts = {
  },
}
