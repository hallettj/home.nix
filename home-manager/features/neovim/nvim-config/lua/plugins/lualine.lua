return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'kyazdani42/nvim-web-devicons' },
  config = function()
    -- Mode is indicated in status line instead
    vim.o.showmode = false

    local filetype_aliases = {
      typescript = 'ts',
      typescriptreact = 'tsx',
    }

    local function truncate(max_len)
      return function(str)
        if string.len(str) <= max_len then
          return str
        end
        return string.sub(str, 1, max_len - 1) .. '…'
      end
    end

    local function format_filetype(ft)
      local alias = filetype_aliases[ft]
      return alias or ft
    end

    local function lsp_status()
      if vim.g.statusbar_show_lsp_status == 1 then
        return vim.lsp.buf.server_ready() and '✔️' or ''
      else
        return ''
      end
    end

    -- Termtoggle provides multiple toggleable terminals that are accessed by
    -- number. For example, `:2ToggleTerm` brings up terminal number 2.
    local function termtoggle_number()
      return vim.b.toggle_number or ''
    end

    require('lualine').setup {
      sections = {
        lualine_a = { 'mode' },
        lualine_b = {
          { 'branch', fmt = truncate(12) },
          'diff', 'diagnostics'
        },
        lualine_c = {
          termtoggle_number,
          'filename',
        },
        lualine_x = {
          { 'filetype', fmt = format_filetype },
          lsp_status,
        },
        lualine_y = { 'progress' },
        lualine_z = { 'location' }
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { { 'filename', path = 1 } },
        lualine_x = { 'location' },
        lualine_y = {},
        lualine_z = {}
      },
    }
  end,
}
