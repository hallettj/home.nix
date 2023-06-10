-- The configuration here works in combination with the vim-auto-save plugin
-- which is configured in `lua/plugins/auto-save.lua`

local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-- Automatically save when the window loses focus or when a buffer is
-- hidden.
vim.o.autoread = true
vim.o.hidden = true

-- Don't keep swap files.
vim.o.swapfile = false
vim.o.backup = false
vim.o.writebackup = true

-- Keep backups for writebackup in a central location
vim.o.backupdir = vim.fn.stdpath('data') .. '/backup//'

-- This isn't used since noswapfile is set, but it's here for symmetry
vim.o.directory = vim.fn.stdpath('data') .. '/swap//'

-- Reduce time to, e.g., CursorHold event
vim.o.updatetime = 300

local group = augroup('my_autosave', { clear = true })

-- Trigger `autoread` when files changes on disk
-- https://unix.stackexchange.com/questions/149209/refresh-changed-content-of-file-opened-in-vim/383044#383044
-- https://vi.stackexchange.com/questions/13692/prevent-focusgained-autocmd-running-in-command-line-editing-mode
autocmd({ 'FocusGained', 'BufEnter' }, {
  group = group,
  pattern = '*',
  callback = function()
    if (vim.api.nvim_get_mode().mode ~= 'c') then
      vim.cmd.checktime()
    end
  end
})

-- Notification after file change
-- https://vi.stackexchange.com/questions/13091/autocmd-event-for-autoread
autocmd('FileChangedShellPost', {
  group = group,
  pattern = '*',
  callback = function()
    vim.api.nvim_echo({ { 'File changed on disk. Buffer reloaded.', 'WarningMsg' } }, false, {})
  end
})
