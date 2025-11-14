{ config, flakePath, lib, ... }:

let
  # Out-of-store symlinks require absolute paths when using a flake config. This
  # is because relative paths are expanded after the flake source is copied to
  # a store path which would get us read-only store paths.
  useOutOfStoreSymlinks =
    if builtins.hasAttr "useOutOfStoreSymlinks" config.home
    then config.home.useOutOfStoreSymlinks
    else false;
  dir = "${flakePath config}/home-manager/features/ssh";
  symlink = path:
    let p = lib.strings.removePrefix "." path; in
    if useOutOfStoreSymlinks then config.lib.file.mkOutOfStoreSymlink dir + p else ./. + p;
in
{
  home.file = {
    ".ssh/config".source = symlink "./config";
  };
}
