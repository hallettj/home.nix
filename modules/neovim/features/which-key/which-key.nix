{
  flake.nvim-config.which-key =
    { pkgs, ... }:
    {
      specs.which-key = {
        data = pkgs.vimPlugins.which-key-nvim;
        config = builtins.readFile ./which-key.lua;
      };
    };
}
