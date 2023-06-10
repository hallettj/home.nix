-- Enable spell checking for additional filetypes. A new vim feature limits
-- spell-checked regions of a file to specific treesitter nodes designated by
-- the treesitter grammar. So I want to turn on spell-checking for a number of
-- programming language filetypes to get spell checking for comments.
local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

local spell_checked_filetypes = {
  'haskell',
  'lua',
  'javascript',
  'python',
  'rust',
  'sh',
  'typescript',
  'zsh',
}

local function has_value(table, value)
  for _, val in ipairs(table) do
    if value == val then
      return true
    end
  end
  return false
end

autocmd('FileType', {
  group = augroup('enable_spell_filetypes', { clear = true }),
  callback = function(args)
    if (has_value(spell_checked_filetypes, args.match)) then
      -- Using vim.opt_local instead of vim.bo because the latter gives an error
      -- about spell being a window option, not a buffer option that I don't
      -- understand.
      vim.opt_local.spell = true
    end
  end,
})
