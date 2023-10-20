{ config, flakePath, pkgs, ... }:

let
  # Out-of-store symlinks require absolute paths when using a flake config. This
  # is because relative paths are expanded after the flake source is copied to
  # a store path which would get us read-only store paths.
  dir = "${flakePath config}/home-manager/features/wezterm";
in
{
  home.packages = with pkgs; [
    wezterm
  ];
  xdg.configFile."wezterm/wezterm.lua".source =
    config.lib.file.mkOutOfStoreSymlink "${dir}/wezterm.lua";
  xdg.configFile."wezterm/autoload/init.lua".source =
    config.lib.file.mkOutOfStoreSymlink "${dir}/autoload/init.lua";
}
