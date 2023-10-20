local wezterm = require 'wezterm'

local config = {}

if wezterm.config_builder then
  config = wezterm.config_builder()
end

config.font = wezterm.font('Cartograph CF', { weight = 'Medium' })
config.font_size = 12
config.line_height = 0.83

config.color_scheme = 'catppuccin-macchiato'

config.hide_tab_bar_if_only_one_tab = true
config.term = 'wezterm'
config.window_decorations = 'RESIZE'
config.window_padding = {
  left = '0.2cell',
  right = '0.2cell',
  top = 0,
  bottom = 0,
}

-- This is the recommended setting for tiling window managers
config.adjust_window_size_when_changing_font_size = false

-- Automatically loads every module in autoload/, and runs the exported
-- `configure` function from each. This helps me to install specialized per-host or
-- per-feature configuration via nix modules.
local autoload = require 'autoload'
autoload.configure(config)

return config
