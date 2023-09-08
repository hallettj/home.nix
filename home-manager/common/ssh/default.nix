{ config, flakePath, ... }:

let
  # Out-of-store symlinks require absolute paths when using a flake config. This
  # is because relative paths are expanded after the flake source is copied to
  # a store path which would get us read-only store paths.
  dir = "${flakePath config}/home-manager/common/ssh";
  symlink = path: config.lib.file.mkOutOfStoreSymlink "${dir}/${path}";
in
{
  home.file = {
    ".ssh/config".source = symlink "config";
  };
}
