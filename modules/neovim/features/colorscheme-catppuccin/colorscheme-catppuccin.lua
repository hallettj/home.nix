-- IMPORTANT!: It is necessary to apply the colorscheme synchronously during
-- startup or the colors come out wrong.
--
-- There is something that automatically links Treesitter highlight
-- groups to generic ones on startup if custom colors or styles are not assigned
-- to Treesitter groups in time. For example `@variable.builtin` gets linked to
-- `TSVariableBuiltin` which gets linked to `Special`. Colors and styles applied
-- to the Treesitter groups after they are linked are ignored.

-- TODO: can I schedule this to run automatically?
-- build = function() require('catppuccin').compile() end,

-- Valid flavours are: 'latte', 'frappe', 'macchiato', 'mocha'
local dark_flavour = "macchiato"
local light_flavour = "latte"

vim.g.catppuccin_flavour = vim.o.background == "light" and light_flavour or dark_flavour

require("catppuccin").setup {
  transparent_background = false,
  term_colors = true,
  compile = {
    enabled = true,
    path = vim.fn.stdpath "cache" .. "/catppuccin",
  },
  styles = {
    comments = { "italic" },
    conditionals = { "italic" },
    loops = {},
    functions = {},
    keywords = { "italic" },
    strings = {},
    variables = {},
    numbers = {},
    booleans = {},
    properties = {},
    types = {},
    operators = {},
  },
  auto_integrations = true,
  integrations = {
    -- For various plugins integrations see https://github.com/catppuccin/nvim#integrations
    blink_cmp = {
      style = "bordered",
    },
    dap = true,
    dap_ui = true,
    fidget = true,
    gitsigns = true,
    leap = true,
    lsp_trouble = true,
    mini = { enabled = true },
    nvim_surround = true,
    render_markdown = true,
    telescope = { enabled = true },
    treesitter = true,
    treesitter_context = true,
    which_key = true,
    markdown = true,
    native_lsp = {
      enabled = true,
      virtual_text = {
        errors = {},
        hints = {},
        warnings = {},
        information = {},
      },
      underlines = {
        errors = { "underline" },
        hints = { "underline" },
        warnings = { "underline" },
        information = { "underline" },
      },
      inlay_hints = {
        background = true,
      },
    },
  },
  custom_highlights = function(colors)
    return {
      ["Boolean"] = { style = { "italic" } },
      ["Include"] = { style = {} }, -- disable italic
      ["Interface"] = { fg = colors.flamingo },
      ["@module"] = { style = {} }, -- some `Include` items are also linked to `@module`
      ["StorageClass"] = { fg = colors.yellow, style = { "italic" } }, -- `&`, `&mut`, and `ref` in Rust
      ["@function.builtin"] = { style = { "italic" } },
      ["@keyword.import"] = { fg = colors.mauve, style = { "italic" } }, -- `use` and `as` in Rust
      ["@parameter"] = { style = {} }, -- disable italic
      ["@variable.builtin"] = { style = { "italic" } }, -- italic for `self` in Rust

      -- messages from vim.notify
      ["ErrorMsg"] = { style = {} },
      ["WarningMsg"] = { style = {} },

      -- Highlights used by tiny-inline-diagnostic
      ["DiagnosticError"] = { style = {} }, -- disable italic style
      ["DiagnosticWarn"] = { style = {} },
      ["DiagnosticInfo"] = { style = {} },
      ["DiagnosticHint"] = { style = {} },

      -- Link lsp groups more precisely
      ["@lsp.type.interface"] = { link = "Interface" },

      -- Modify semantic highlighting to make highlighting for strings transparent.
      -- This prevents semantic highlighting from overriding highlighting from
      -- treesitter language injections, like my sqlx::query!() injection.
      ["@lsp.type.string"] = {},

      -- I'm using @markup.normal in my sqlx injection for nodes that the
      -- sql queries don't otherwise highlight. This makes those nodes
      -- white, instead of using the green highlighting used for strings.
      ["@markup.normal"] = { link = "Normal" },
    }
  end,
}

local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

local group = augroup("custom_catppuccin_hooks", { clear = true })

-- Switch colorscheme flavours on background setting change.
autocmd("OptionSet", {
  group = group,
  pattern = "background",
  callback = function()
    if vim.g.colors_name == "catppuccin" then
      vim.cmd.Catppuccin(vim.v.option_new == "light" and light_flavour or dark_flavour)
    end
  end,
})

vim.cmd.colorscheme "catppuccin"
