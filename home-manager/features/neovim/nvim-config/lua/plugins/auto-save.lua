return {
  '907th/vim-auto-save',
  init = function()
    vim.g.auto_save = 1
    vim.g.auto_save_silent = 1

    -- Disable autosave in Cargo.toml - constant workspace reloading is too
    -- disruptive.
    vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead' }, {
      group = vim.api.nvim_create_augroup('vim-autosave-hooks', { clear = true }),
      pattern = 'Cargo.toml',
      callback = function()
        vim.b.auto_save = 0
      end
    })
  end,
}
