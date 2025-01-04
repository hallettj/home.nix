-- Wrap a lazy.nvim plugin spec to tell lazy to load a plugin installed by nix
--
-- NOTE: For this to work you must configure lazy.nvim with this option:
-- 
--     require('lazy').setup {
--       ...
--       performance = {
--         reset_packpath = false,
--       },
--     }
--
-- Thanks to debugloop! This is adapted from source at,
-- https://github.com/debugloop/dotfiles/blob/80903ff02909ce1cf34b1a4870b7758a78e1b3a0/home/nvim/lua/plugins.lua#L1
local function from_nixpkgs(spec)
  if type(spec) ~= 'table' then
    vim.notify('Encountered bad plugin spec. Must use a table, not string. Check config.', vim.log.levels.ERROR)
    return spec
  end

  if spec['clone'] then
    return spec
  end

  if spec['dir'] == nil and spec['dev'] ~= true then
    local plugin_name = spec[1]:match('[^/]+$')
    local nixpkgs_dir = vim.fn.stdpath('data') .. '/nixpkgs/' .. plugin_name:gsub('%.', '-')
    if vim.fn.isdirectory(nixpkgs_dir) == 1 then
      spec['dir'] = nixpkgs_dir
    end
  end
  return spec
end

return {
  from_nixpkgs = from_nixpkgs,
}
