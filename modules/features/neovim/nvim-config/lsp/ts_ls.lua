-- Configuration to make lsp-inlayhints.nvim work with TypeScript
local ts_ls = {
  inlayHints = {
    includeInlayParameterNameHints = 'all',
    includeInlayParameterNameHintsWhenArgumentMatchesName = false,
    includeInlayFunctionParameterTypeHints = true,
    includeInlayVariableTypeHints = true,
    includeInlayPropertyDeclarationTypeHints = true,
    includeInlayFunctionLikeReturnTypeHints = true,
    includeInlayEnumMemberValueHints = true,
  }
}

-- Suppress debug assertions in LSP notifications that steal focus.
-- These can arrive via window/showMessage, window/logMessage, or stderr
-- (which bypasses LSP handlers and goes directly to vim.notify).
local function is_suppressed_message(msg)
  return type(msg) == 'string' and msg:find("Debug Failure. Unexpected node.")
end

local orig_notify = vim.notify
vim.notify = function(msg, level, opts)
  if is_suppressed_message(msg) then
    local node = msg:match("Node (%S+) was unexpected") or "unknown"
    orig_notify("ts_ls: Debug Failure (Node " .. node .. " was unexpected)", vim.log.levels.WARN, opts)
    return
  end
  orig_notify(msg, level, opts)
end

return {
  settings = {
    typescript = ts_ls,
    javascript = ts_ls,
  },
}
