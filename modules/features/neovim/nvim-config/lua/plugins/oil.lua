-- file browser to replace netrw
return {
  'stevearc/oil.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  lazy = false, -- ssh connections do not initialize properly when loaded lazily
  keys = {
    { '_', function() require('oil').open() end, desc = 'Browse parent directory' },
  },
  opts = {
    keymaps = {
      ['g?'] = 'actions.show_help',
      ['<CR>'] = 'actions.select',
      ['<C-v>'] = 'actions.select_vsplit',
      ['<C-s>'] = 'actions.select_split',
      -- ['<C-t>'] = 'actions.select_tab',
      -- ['<C-p>'] = 'actions.preview', -- conflicts with my file picker
      ['<C-c>'] = 'actions.close',
      ['<C-l>'] = 'actions.refresh',
      ['_'] = 'actions.parent',
      ['`'] = 'actions.cd',
      ['~'] = 'actions.tcd',
      ['g.'] = 'actions.toggle_hidden',
    },
    use_default_keymaps = false,
    skip_confirm_for_simple_edits = true,
  },
}
