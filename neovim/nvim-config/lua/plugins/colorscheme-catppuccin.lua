-- IMPORTANT!: It is necessary to apply the colorscheme synchronously during
-- startup or the colors come out wrong.
--
-- There is something that automatically links Treesitter highlight
-- groups to generic ones on startup if custom colors or styles are not assigned
-- to Treesitter groups in time. For example `@variable.builtin` gets linked to
-- `TSVariableBuiltin` which gets linked to `Special`. Colors and styles applied
-- to the Treesitter groups after they are linked are ignored.

return {
  'catppuccin/nvim',
  main = 'catppuccin',
  dependencies = { 'nvim-treesitter/nvim-treesitter' },

  -- The main colorscheme must be loaded synchronously - otherwise neovim does
  -- some automatic highlight group aliasing that messes things up. So we
  -- disable lazy loading, and set a high priority.
  lazy = false, priority = 1000,

  build = function() require('catppuccin').compile() end,
  config = function()
    -- Valid flavours are: 'latte', 'frappe', 'macchiato', 'mocha'
    local dark_flavour = 'macchiato'
    local light_flavour = 'latte'

    vim.g.catppuccin_flavour = vim.o.background == 'light' and light_flavour or dark_flavour

    require('catppuccin').setup({
      transparent_background = false,
      term_colors = true,
      compile = {
        enabled = true,
        path = vim.fn.stdpath('cache') .. '/catppuccin',
      },
      styles = {
        comments = { 'italic' },
        conditionals = { 'italic' },
        loops = {},
        functions = {},
        keywords = { 'italic' },
        strings = {},
        variables = {},
        numbers = {},
        booleans = {},
        properties = {},
        types = {},
        operators = {},
      },
      integrations = {
        -- For various plugins integrations see https://github.com/catppuccin/nvim#integrations
        cmp = true,
        dap = {
          enabled = true,
        },
        fidget = true,
        gitsigns = true,
        leap = true,
        lsp_trouble = true,
        telescope = true,
        treesitter = true,
        which_key = true,
        markdown = true,
        mason = true,
        native_lsp = {
          enabled = true,
          virtual_text = {
            errors = {},
            hints = {},
            warnings = {},
            information = {},
          },
          underlines = {
            errors = { 'underline' },
            hints = { 'underline' },
            warnings = { 'underline' },
            information = { 'underline' },
          },
        },
      },
      -- Treesitter recently introduced highlight group names of the form
      -- `@namespace` as opposed to the previously-used form `TSNamespace`. The old
      -- highlight group names still exist, but Catppuccin has updated to use the
      -- new ones if they are available; so the old group names don't work for
      -- Catppuccin customization.
      --
      -- This whole system might change again before nvim 0.8 is stabilized. See
      -- https://github.com/nvim-treesitter/nvim-treesitter/pull/3365
      custom_highlights = {
        ['Boolean'] = { style = { 'italic' } },
        ['@function.builtin'] = { style = { 'italic' } },
        ['@keyword.operator'] = { style = { 'italic' } },
        -- disable italic for parameters
        ['@parameter'] = { style = {} },
        ['@namespace'] = { style = {} },
        -- italic for `for` in `impl X for Y` in Rust
        ['@repeat'] = { style = { 'italic' } },
        -- italic for `self` in Rust
        ['@variable.builtin'] = { style = { 'italic' } },
        -- messages from vim.notify
        ['ErrorMsg'] = { style = {} },
        ['WarningMsg'] = { style = {} },
      },
    })

    local autocmd = vim.api.nvim_create_autocmd
    local augroup = vim.api.nvim_create_augroup

    local group = augroup('custom_catppuccin_hooks', { clear = true })

    -- Switch colorscheme flavours on background setting change.
    autocmd('OptionSet', {
      group = group,
      pattern = 'background',
      callback = function()
        if (vim.g.colors_name == 'catppuccin') then
          vim.cmd.Catppuccin(vim.v.option_new == 'light' and light_flavour or dark_flavour)
        end
      end,
    })

    vim.cmd.colorscheme 'catppuccin'
  end,
}
