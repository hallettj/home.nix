-- Require all other `.lua` files in the same directory. Run the `configure`
-- function exported by each.

local wezterm = require 'wezterm'

local module = {}

-- Apparently the name of this module is given as an argument when it is
-- required, and apparently we get that argument with three dots.
local module_name = ...
local module_dir = wezterm.config_dir .. '/' .. module_name

local function basename(path)
  return string.match(path, '[^/]+$')
end

local function scandir(directory)
  local t = {}
  for i, filename in ipairs(wezterm.read_dir(directory)) do
    t[i] = basename(filename)
  end
  return t
end

local function is_autoload_module(filename)
  local is_lua_module = string.match(filename, '[.]lua$')
  local is_init = filename == 'init.lua'
  return is_lua_module and not is_init
end

function module.configure(config)
  local files_in_autoload_dir = scandir(module_dir)
  for _, filename in ipairs(files_in_autoload_dir) do
    if is_autoload_module(filename) then
      local autoload_module = string.match(filename, '(.+).lua$')
      local m = require(module_name .. '.' .. autoload_module)
      if type(m) ~= 'table' or m.configure == nil then
        wezterm.log_error('lua modules in ' .. module_dir .. ' should return a table with a `configure` function')
      else
        m.configure(config)
      end
    end
  end
end

return module
