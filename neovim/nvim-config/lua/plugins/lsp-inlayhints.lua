return {
  'lvimuser/lsp-inlayhints.nvim',
  config = function()
    local autocmd = vim.api.nvim_create_autocmd
    local augroup = vim.api.nvim_create_augroup

    require('lsp-inlayhints').setup {}

    local lsp_augroup = augroup('LSP_preferences', { clear = true })
    autocmd('LspAttach', {
      group = lsp_augroup,
      callback = function(args)
        if not (args.data and args.data.client_id) then
          return
        end

        local bufnr = args.buf
        local client = vim.lsp.get_client_by_id(args.data.client_id)

        -- Start lsp-inlayhints to display virtual text hints for function return
        -- types, parameter names, etc.
        require('lsp-inlayhints').on_attach(client, bufnr)

        -- Show code lenses including, for example, imported symbols for blanket
        -- import lines in Haskell modules. This also enables code lens actions.
        -- Code lenses don't show up unless the `refresh` function is called.
        --
        -- Code lenses are not directly related to inlay hints, and code lenses do
        -- not use the lsp-inlayhints plugin. But it is convenient to put this
        -- configuration here.
        if client.server_capabilities.codeLensProvider then
          autocmd({ 'BufEnter', 'CursorHold', 'InsertLeave' }, {
            group = lsp_augroup,
            buffer = bufnr,
            callback = vim.lsp.codelens.refresh,
          })
        end
      end,
    })
  end,
}
