local hostname = string.gsub(vim.fn.system('hostname'), '^%s*(.-)%s*$', '%1')
local font_size = hostname == 'battuta' and '20' or '12'

if vim.g.neovide then
  vim.opt.guifont = { 'Cartograph CF:h' .. font_size .. ':#e-subpixelantialias:#h-none' }
  vim.opt.linespace = -4 -- Cartograph works better with tighter linespacing
  vim.opt.title = true
  vim.g.neovide_refresh_rate = 72
  vim.g.neovide_remember_window_position = false
  vim.g.neovide_remember_window_size = false
  vim.g.neovide_hide_mouse_when_typing = true
  vim.g.neovide_scroll_animation_length = 0.12
end
