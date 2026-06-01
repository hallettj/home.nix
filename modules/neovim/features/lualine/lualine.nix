{
  flake.nvim-config.lualine =
    { pkgs, ... }:
    {
      specs.lualine = {
        data = with pkgs.vimPlugins; [
          nvim-web-devicons
          lualine-nvim
        ];
        config = builtins.readFile ./lualine.lua;
      };
    };
}
