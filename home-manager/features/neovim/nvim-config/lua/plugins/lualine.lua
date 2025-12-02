return {
  'nvim-lualine/lualine.nvim',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
  },
  config = function()
    -- Mode is indicated in status line instead
    vim.o.showmode = false

    local filetype_aliases = {
      typescript = 'ts',
      typescriptreact = 'tsx',
    }

    -- Define a consistent order for displaying formatoptions based on order in :h fo-table
    local fo_order = { 't', 'c', 'r', 'o', '/', 'q', 'w', 'a', 'n', '2', 'v', 'b', 'l', 'm', 'M', 'B', '1', ']', 'j', 'p' }
    local fo_order_index = {}
    for i, char in ipairs(fo_order) do
      fo_order_index[char] = i
    end

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

    local function format_options()
      local fo = vim.api.nvim_get_option_value('formatoptions', {})
      local chars = {}
      for char in fo:gmatch('.') do
        table.insert(chars, char)
      end
      table.sort(chars, function(a, b)
        local pos_a = fo_order_index[a] or 999
        local pos_b = fo_order_index[b] or 999
        return pos_a < pos_b
      end)
      return table.concat(chars, '')
    end

    -- Termtoggle provides multiple toggleable terminals that are accessed by
    -- number. For example, `:2ToggleTerm` brings up terminal number 2.
    local function termtoggle_number()
      return vim.b.toggle_number or ''
    end

    require('lualine').setup {
      theme = 'catppuccin',
      sections = {
        lualine_a = { 'mode' },
        lualine_b = {
          { 'branch', fmt = truncate(12) },
          'diff',
          'diagnostics',
        },
        lualine_c = {
          termtoggle_number,
          'filename',
        },
        lualine_x = {
          { 'filetype', fmt = format_filetype },
          format_options,
        },
        lualine_y = { 'progress' },
        lualine_z = { 'location' },
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
