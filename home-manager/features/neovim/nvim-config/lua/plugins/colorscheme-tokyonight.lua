return {
  'folke/tokyonight.nvim',
  lazy = true,
  opts = {
    terminal_colors = true, -- Configure the colors used when opening a `:terminal` in Neovim
    styles = {
      -- Style to be applied to different syntax groups
      -- Value is any valid attr-list value for `:help nvim_set_hl`
      comments = 'italic',
      keywords = 'italic',
      functions = 'NONE',
      variables = 'NONE',
      -- Background styles. Can be "dark", "transparent" or "normal"
      sidebars = 'dark', -- style for sidebars, see below
      floats = 'dark', -- style for floating windows
    },
    sidebars = { 'qf', 'help' }, -- Set a darker background on sidebar-like windows. For example: `["qf", "vista_kind", "terminal", "packer"]`

    --- You can override specific highlights to use other groups or a hex color
    --- fucntion will be called with a Highlights and ColorScheme table
    ---@param hl Highlights
    ---@param colors ColorScheme
    on_highlights = function(hl)
      hl.TSConditional = hl.TSKeyword
      hl.TSConstBuiltin = { style = 'italic' }
      hl.TSFuncBuiltin = { style = 'italic' }
      hl.TSKeywordFunction = hl.TSKeyword
      hl.TSLabel = hl.Type -- in Rust lifetimes ar labelled TSLabel
      -- TSRepeat applies to `for` in `impl X for Y` in Rust
      hl.TSRepeat = hl.TSKeyword
      hl.TSVariableBuiltin = vim.tbl_extend('keep',
        { style = 'italic' },
        hl.TSVariableBuiltin
      )
    end,
  },
}
