-- Search & Replace UI
return {
  'nvim-pack/nvim-spectre',
  dependencies = { 'nvim-lua/plenary.nvim' },
  keys = {
    { '<leader>S',  function() require('spectre').toggle() end,                                 desc = 'toggle Spectre search & replace UI' },
    { '<leader>sw', function() require('spectre').open_visual({ select_word = true }) end,      desc = 'search for word under cursor', },
    { '<leader>sw', function() require('spectre').open_visual() end,                            desc = 'search for word under cursor',        mode = { 'v' } },
    { '<leader>sp', function() require('spectre').open_file_search({ select_word = true }) end, desc = 'search for word under cursor in file' },
  },
}
