-- Mode is indicated in status line instead
vim.o.showmode = false

local filetype_aliases = {
  typescript = "ts",
  typescriptreact = "tsx",
}

local mode_short = {
  NORMAL = "N",
  INSERT = "I",
  COMMAND = "C",
  TERMINAL = "T",
  VISUAL = "V",
  ["V-LINE"] = "VL",
  ["V-BLOCK"] = "VB",
  SELECT = "S",
  ["S-LINE"] = "SL",
  ["S-BLOCK"] = "SB",
  REPLACE = "R",
  ["V-REPLACE"] = "VR",
}

-- Define a consistent order for displaying formatoptions based on order in :h fo-table
local fo_order = { "t", "c", "r", "o", "/", "q", "w", "a", "n", "2", "v", "b", "l", "m", "M", "B", "1", "]", "j", "p" }
local fo_order_index = {}
for i, char in ipairs(fo_order) do
  fo_order_index[char] = i
end

local function format_filetype(ft)
  local alias = filetype_aliases[ft]
  return alias or ft
end

local function format_options()
  local fo = vim.api.nvim_get_option_value("formatoptions", {})
  local chars = {}
  for char in fo:gmatch "." do
    table.insert(chars, char)
  end
  table.sort(chars, function(a, b)
    local pos_a = fo_order_index[a] or 999
    local pos_b = fo_order_index[b] or 999
    return pos_a < pos_b
  end)
  return table.concat(chars, "")
end

local function wrapping_mode()
  local mode = require("wrapping").get_current_mode()
  if mode then
    return mode
  else
    return ""
  end
end

-- Termtoggle provides multiple toggleable terminals that are accessed by
-- number. For example, `:2ToggleTerm` brings up terminal number 2.
local function termtoggle_number() return vim.b.toggle_number or "" end

-- Maps single-number ANSI foreground codes to terminal palette indices
local ansi_fg_to_term = {
  [30] = 0,
  [31] = 1,
  [32] = 2,
  [33] = 3,
  [34] = 4,
  [35] = 5,
  [36] = 6,
  [37] = 7,
  [90] = 8,
  [91] = 9,
  [92] = 10,
  [93] = 11,
  [94] = 12,
  [95] = 13,
  [96] = 14,
  [97] = 15,
}

local function setup_jj_hl()
  local ok, base = pcall(vim.api.nvim_get_hl, 0, { name = "lualine_b_normal", link = false })
  local bg = ok and base and base.bg or nil
  for ansi, term_idx in pairs(ansi_fg_to_term) do
    local fg = vim.g["terminal_color_" .. term_idx]
    if fg then
      vim.api.nvim_set_hl(0, "LualineJJ_" .. ansi, { fg = fg, bg = bg })
    end
  end
end

vim.api.nvim_create_autocmd("ColorScheme", { callback = setup_jj_hl })

local function ansi_to_statusline(s)
  s = s:gsub("\27%[(%d+)m", function(code)
    local n = tonumber(code)
    if n == 0 then
      return "%#lualine_b_normal#"
    end
    if ansi_fg_to_term[n] then
      return "%#LualineJJ_" .. code .. "#"
    end
    return ""
  end)
  return s:gsub("\n+$", "")
end

local jj_status_cache = ""

local function update_jj_status()
  vim.fn.jobstart({
    "jj-starship",
    "--no-git-id",
    "--bookmarks-display-limit=1",
    "--strip-bookmark-prefix=jesse/,hallettj/",
    "--truncate-name=18",
  }, {
    stdout_buffered = true,
    on_stdout = function(_, data)
      if data then
        jj_status_cache = ansi_to_statusline(table.concat(data, ""))
        jj_status_cache = jj_status_cache:gsub("on ", "") -- remove the word "on" from the start of the status
      end
    end,
    on_exit = function(_, code)
      if code ~= 0 then
        jj_status_cache = ""
      end
    end,
  })
end

vim.api.nvim_create_autocmd({ "VimEnter", "BufEnter", "BufWritePost", "FocusGained", "DirChanged" }, {
  group = vim.api.nvim_create_augroup("update_jj_status", { clear = true }),
  callback = update_jj_status,
})

local function jj_status() return jj_status_cache end

require("lualine").setup {
  theme = "catppuccin",
  sections = {
    lualine_a = { { "mode", fmt = function(s) return mode_short[s] or s:sub(1, 1) end } },
    lualine_b = {
      jj_status,
      "diagnostics",
    },
    lualine_c = {
      termtoggle_number,
      "filename",
    },
    lualine_x = {
      { "filetype", fmt = format_filetype },
      format_options,
      wrapping_mode,
    },
    lualine_y = { "progress" },
    lualine_z = { "location" },
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { { "filename", path = 1 } },
    lualine_x = { "location" },
    lualine_y = {},
    lualine_z = {},
  },
}

setup_jj_hl() -- lualine_b_normal and terminal_color_N are defined by this point
