-- Wrap a lazy.nvim plugin spec to tell lazy to load a plugin installed by nix.
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

    -- Neovim plugins can be installed in Nix using Home Manager. For example,
    --
    --     programs.neovim = {
    --       enable = true;
    --       plugins = [
    --         { plugin = pkgs.vimPlugins.nvim-treesitter.withAllGrammars; type = "lua"; optional = true; }
    --       ];
    --     };
    --
    -- Home Manager creates a nix store path with a pack directory containing
    -- all of the plugins installed this way (inside a structure of
    -- subdirectories). It wraps neovim to add that nix store path to the neovim
    -- `packpath` setting. This code iterates through `packpath` entries to
    -- attempt to find the plugin we're looking for.
    --
    -- This effectively duplicates the logic of `:packadd`. If there is a neovim
    -- API to get a pack path by name that could be used instead.
    local nixpkgs_dir = vim.iter(vim.opt.packpath:get())
        :map(function(dir)
          local nix_packs_subdir = dir .. '/pack/myNeovimPackages'
          local start_subdir = nix_packs_subdir .. '/start/' .. plugin_name
          local opt_subdir = nix_packs_subdir .. '/opt/' .. plugin_name
          return { start_subdir, opt_subdir }
        end)
        :flatten()
        :find(function(dir)
          return vim.fn.isdirectory(dir) == 1
        end)

    if nixpkgs_dir then
      spec['dir'] = nixpkgs_dir
    else
      error('could not find nix package for plugin, ' .. plugin_name)
    end
  end
  return spec
end

return {
  from_nixpkgs = from_nixpkgs,
}
