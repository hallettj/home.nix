{ config, flakePath, pkgs, ... }:

let
  # Out-of-store symlinks require absolute paths when using a flake config. This
  # is because relative paths are expanded after the flake source is copied to
  # a store path which would get us read-only store paths.
  dir = "${flakePath config}/home-manager/features/kitty";
in
{
  home.file.kitty-config = {
    source = config.lib.file.mkOutOfStoreSymlink "${dir}/kitty-config";
    target = ".config/kitty";
  };

  home.packages = with pkgs; [
    kitty
    kitty-themes

    # Need a nerdfont to get icons. Another option could be "NerdFontsSymbolsOnly".
    (nerdfonts.override { fonts = [ "FiraCode" ]; })
  ];
}
