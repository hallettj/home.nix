{
  flake.nvim-config.obsidian =
    { pkgs, ... }:
    {
      specs.obsidian = {
        data = pkgs.vimPlugins.obsidian-nvim;
        after = [ "lze" "blink" "telescope" ];
        lazy = true;
        config = builtins.readFile ./obsidian.lua;
      };

      runtimePkgs = with pkgs; [
        ripgrep
      ];
    };
}
