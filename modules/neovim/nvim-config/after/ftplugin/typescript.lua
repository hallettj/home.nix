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

-- Pair angle brackets. mini.pairs does not map "<" because in most languages it
-- is a comparison operator, but in TypeScript it also opens generics (`Array<`,
-- `const f = <T,>() => {}`) and in typescriptreact it opens tags
-- (`return <div>`). The heuristics below try to tell those apart from an
-- inequality test.
local MiniPairs = require "mini.pairs"

-- Words that cannot end an expression, so a "<" after one of them is a generic
-- or a tag rather than a comparison. (`=>` is handled separately since it is
-- not a word.)
local non_expression_keywords = {
  ["as"] = true,
  ["await"] = true,
  ["case"] = true,
  ["default"] = true,
  ["do"] = true,
  ["else"] = true,
  ["extends"] = true,
  ["in"] = true,
  ["infer"] = true,
  ["instanceof"] = true,
  ["keyof"] = true,
  ["new"] = true,
  ["of"] = true,
  ["return"] = true,
  ["satisfies"] = true,
  ["throw"] = true,
  ["typeof"] = true,
  ["yield"] = true,
}

-- Should a "<" typed at the cursor open a "<>" pair?
local function angle_opens_pair()
  local col = vim.fn.col "." - 1
  local before = vim.api.nvim_get_current_line():sub(1, col)

  -- No space before the cursor: the generic case, `Array<`. Also covers
  -- operator positions with no space, like `(<` or `=<`. The only space-free
  -- text that ends an expression is a closing bracket, as in `f()<n` or
  -- `a[i]<n`.
  --
  -- NOTE: this is where the heuristic knowingly guesses wrong: a space-free
  -- comparison like `i<n` looks exactly like a generic.
  if not before:match "%s$" then
    return before:match "[%)%]]$" == nil
  end

  -- There is a space before the cursor, so look at the token before the space.
  -- An inequality test has a complete expression there; generics and tags
  -- appear after an operator, a keyword, `=>`, or nothing at all (start of
  -- line).
  local trimmed = (before:gsub("%s+$", ""))
  local word = trimmed:match "[%w_$]+$"
  if word ~= nil then
    return non_expression_keywords[word] == true
  end
  return trimmed:match "[%)%]\"'`]$" == nil
end

-- `neigh_pattern` only sees one character on either side of the cursor, which is
-- not enough context for the heuristics above, so the "<" mapping has to be
-- written by hand. `map_buf` still runs first because it is what registers "<>"
-- with <BS>, so that backspacing over a "<" that was just paired deletes the
-- ">" too; the hand-written mapping then replaces the one it created.
MiniPairs.map_buf(0, "i", "<", {
  action = "open",
  pair = "<>",
  register = { bs = true, cr = true },
})
vim.keymap.set("i", "<", function() return angle_opens_pair() and MiniPairs.open "<>" or "<" end, {
  buffer = 0,
  expr = true,
  replace_keycodes = false, -- MiniPairs.open returns terminal codes
  desc = "MiniPairs <>",
})

-- Maps ">" to type over an existing ">" instead of inserting a second one.
MiniPairs.map_buf(0, "i", ">", {
  action = "close",
  pair = "<>",
  register = { bs = true, cr = true },
})
