local bufnr = vim.api.nvim_get_current_buf()
local set = vim.keymap.set

set({ 'n', 'x' }, '<leader>cc', function()
    vim.cmd.RustLsp('codeAction') -- supports rust-analyzer's grouping
    -- or vim.lsp.buf.codeAction() if you don't want grouping.
  end,
  { silent = true, buffer = bufnr, desc = 'code actions at cursor or selection' }
)

set('n', '<leader>dd', function()
    vim.cmd.RustLsp('debug')
  end,
  { silent = true, buffer = bufnr, desc = 'debug target at cursor' }
)

set('n', '<leader>D', function()
    vim.cmd.RustLsp { 'debuggables', bang = true }
  end,
  { silent = true, buffer = bufnr, desc = 'debug last target again' }
)

set('n', '<leader>rr', function()
    vim.cmd.RustLsp('run')
  end,
  { silent = true, buffer = bufnr, desc = 'run target at cursor' }
)

set('n', '<leader>R', function()
    vim.cmd.RustLsp { 'run', bang = true }
  end,
  { silent = true, buffer = bufnr, desc = 'run last target again' }
)
