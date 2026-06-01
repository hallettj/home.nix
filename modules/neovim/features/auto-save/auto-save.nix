{
  flake.nvim-config.auto-save =
    { pkgs, ... }:
    {
      specs.auto-save = {
        data = pkgs.vimPlugins.vim-auto-save;
        config = builtins.readFile ./auto-save.lua;
      };
    };
}
