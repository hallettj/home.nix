{ config, flakePath, pkgs, ... }:

let
  # Out-of-store symlinks require absolute paths when using a flake config. This
  # is because relative paths are expanded after the flake source is copied to
  # a store path which would get us read-only store paths.
  dir = "${flakePath config}/home-manager/features/niri";
in
{
  home.packages = with pkgs; [
    niri # run with steam-run; package expression is in pkgs/niri.nix
  ];

  xdg.configFile.niri = {
    source = config.lib.file.mkOutOfStoreSymlink "${dir}/niri-config";
  };
}
