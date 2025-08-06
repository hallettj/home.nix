local highlight_namespace = vim.api.nvim_create_namespace('highlight_cursor')
vim.api.nvim_set_hl(highlight_namespace, 'CursorLine', { bg = '#fe640b' }) -- Catppuccin peach

local function highlight_cursor()
  local previous_cursorline = vim.o.cursorline
  local previous_hl_ns = vim.api.nvim_get_hl_ns({})

  local timer, err = vim.loop.new_timer()
  if timer == nil then
    vim.print('error highlighting cursor line: ' .. tostring(err))
    return
  end

  vim.api.nvim_win_set_hl_ns(0, highlight_namespace)
  vim.o.cursorline = true

  timer:start(150, 0, vim.schedule_wrap(function()
    vim.o.cursorline = previous_cursorline
    vim.api.nvim_win_set_hl_ns(0, previous_hl_ns)
  end))
end

vim.keymap.set({ 'n', 'x', 'o' }, '<leader>hc', highlight_cursor, { desc = 'Highlight cursor' })
