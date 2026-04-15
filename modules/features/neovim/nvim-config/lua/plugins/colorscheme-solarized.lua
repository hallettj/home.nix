return {
  'ishan9299/nvim-solarized-lua',
  main = 'solarized',
  lazy = true,
  config = function()
    local cmd = vim.cmd
    local highlight = require('solarized.utils').highlighter

    local darkColors = {
      none    = { 'none', 'none' },
      base02  = { '#073642', 15 },
      red     = { '#dc322f', 193 },
      green   = { '#859900', 133 },
      yellow  = { '#b58900', 171 },
      blue    = { '#268bd2', 56 },
      magenta = { '#d33682', 188 },
      cyan    = { '#2aa198', 61 },
      base2   = { '#eee8d5', 238 },
      base03  = { '#002b36', 7 },
      back    = { '#002b36', 7 },
      orange  = { '#cb4b16', 182 },
      base01  = { '#586e75', 92 },
      base00  = { '#657b83', 105 },
      base0   = { '#839496', 134 },
      violet  = { '#6c71c4', 111 },
      base1   = { '#93a1a1', 150 },
      base3   = { '#fdf6e3', 253 },
      err_bg  = { '#fdf6e3', 253 }
    }

    local lightColors = {
      none    = { 'none', 'none' },
      base2   = { '#073642', 15 },
      red     = { '#dc322f', 193 },
      green   = { '#859900', 133 },
      yellow  = { '#b58900', 171 },
      blue    = { '#268bd2', 56 },
      magenta = { '#d33682', 188 },
      cyan    = { '#2aa198', 61 },
      base02  = { '#eee8d5', 238 },
      base3   = { '#002b36', 7 },
      orange  = { '#cb4b16', 182 },
      base1   = { '#586e75', 92 },
      base0   = { '#657b83', 105 },
      base00  = { '#839496', 134 },
      violet  = { '#6c71c4', 111 },
      base01  = { '#93a1a1', 150 },
      base03  = { '#fdf6e3', 253 },
      back    = { '#fdf6e3', 253 },
      err_bg  = { '#fdf6e3', 253 }
    }

    local diagnostic_coc_labels = {
      Error = 'Error',
      Warn  = 'Warning',
      Info  = 'Info',
      Hint  = 'Hint',
    }

    local function my_solarized_customizations()
      local is_dark = vim.o.background == 'dark'
      local c = is_dark and darkColors or lightColors
      local diagnostic_colors = {
        Error = c.red,
        Warn  = c.orange,
        Info  = c.base01,
        Hint  = c.base01,
      }

      -- color for virtual text for coc lens - e.g. "1 implementation"
      highlight('CocCodeLens', { fg = c.base01 })

      -- floating window colors
      highlight('NormalFloat', { fg = c.none, bg = c.base02 })
      highlight('Pmenu', { fg = c.none, bg = c.base02 })

      for level, color in pairs(diagnostic_colors) do
        -- color for Coc's diagnostic signs in the left gutter
        highlight('DiagnosticSign' .. level, { fg = color })
        cmd('highlight! link Coc' .. diagnostic_coc_labels[level] .. 'Sign DiagnosticSign' .. level)

        -- draw undercurls under portions of code with diagnostic messages
        highlight('DiagnosticUnderline' .. level, { fg = c.none, guisp = color, style = 'undercurl' })
        cmd('highlight! link Coc' .. diagnostic_coc_labels[level] .. 'Highlight DiagnosticUnderline' .. level)

        -- color for virtual text for Coc's diagnostic messages
        highlight('DiagnosticVirtualText' .. level, { fg = color })
        cmd('highlight! link Coc' .. diagnostic_coc_labels[level] .. 'VirtualText DiagnosticVirtualText' .. level)
      end

      highlight('DiffAdd', { fg = c.green, bg = c.none })
      highlight('DiffChange', { fg = c.orange, bg = c.none })
      highlight('DiffDelete', { fg = c.red, bg = c.none })
      cmd('highlight! link GitSignsAdd DiffAdd')
      cmd('highlight! link GitSignsChange DiffChange')
      cmd('highlight! link GitSignsDelete DiffDelete')
    end

    vim.api.nvim_create_augroup('MySolarizedCustomizations', { clear = true })
    vim.api.nvim_create_autocmd('ColorScheme', {
      group = 'MySolarizedCustomizations',
      pattern = 'solarized',
      callback = my_solarized_customizations,
    })

    vim.o.termguicolors = true
    vim.o.background = 'dark'
  end,
}
