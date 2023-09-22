{ config, flakePath, pkgs, ... }:

let
  # Out-of-store symlinks require absolute paths when using a flake config. This
  # is because relative paths are expanded after the flake source is copied to
  # a store path which would get us read-only store paths.
  dir = "${flakePath config}/home-manager/features/kitty";
in
{
  programs.kitty = {
    enable = true;
    settings = {
      include = "${dir}/kitty.conf";
    };
  };

  home.packages = with pkgs; [
    kitty-themes

    # Need a nerdfont to get icons
    (nerdfonts.override { fonts = [ "NerdFontsSymbolsOnly" ]; })
  ];
}
