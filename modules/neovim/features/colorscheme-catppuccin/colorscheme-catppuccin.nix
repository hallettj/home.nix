{
  flake.nvim-config.colorscheme-catppuccin =
    { pkgs, ... }:
    {
      specs.colorscheme-catppuccin = {
        data = pkgs.vimPlugins.catppuccin-nvim;
        after = [ "treesitter" ];
        config = builtins.readFile ./colorscheme-catppuccin.lua;
      };

      # Catppuccin integration detection requires git
      runtimePkgs = [ pkgs.git ];
    };
}
