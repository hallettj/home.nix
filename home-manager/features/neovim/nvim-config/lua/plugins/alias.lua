return {
  'Konfekt/vim-alias',
  config = function()
    -- Shortcuts for git operations to match some of the shell aliases I have.
    -- For example, `:sw ` expands to `:Git switch `
    vim.cmd [[Alias sw Git\ switch]]
    vim.cmd [[Alias ci Git\ commit]]
    vim.cmd [[Alias pull Git\ pull]]
    vim.cmd [[Alias push Git\ push]]
    vim.cmd [[Alias show Git\ show]]
    vim.cmd [[Alias re Git\ restore]]
  end,
}
