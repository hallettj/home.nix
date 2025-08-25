local function organize_imports()
  local params = {
    command = '_typescript.organizeImports',
    arguments = { vim.api.nvim_buf_get_name(0) },
    title = ''
  }
  vim.lsp.buf.execute_command(params)
end

vim.keymap.set({ 'n' }, 'gI', organize_imports, { desc = 'organize imports' })
