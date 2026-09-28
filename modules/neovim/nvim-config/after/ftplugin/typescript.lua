-- Find available LSP commands or code actions with with:
--
--     :lua for _, c in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do vim.print(c.name, c.server_capabilities) end

local function organize_imports()
  vim.lsp.buf.code_action {
    context = { only = { "source.organizeImports" } },
    apply = true,
  }
end

vim.keymap.set({ "n" }, "gI", organize_imports, { desc = "organize imports" })
