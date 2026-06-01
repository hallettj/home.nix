local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-- Resize splits equally when application window size changes
autocmd('VimResized', {
  group = augroup('resize_splits_on_window_resize', { clear = true }),
  callback = function ()
    vim.cmd [[horizontal wincmd =]]
  end
})
