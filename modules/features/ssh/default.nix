flakeParts:

let
  flakePath = flakeParts.config.flakePath;
in
{
  flake.modules.homeManager.ssh =
    { config, ... }:

    let
      # Out-of-store symlinks require absolute paths when using a flake config. This
      # is because relative paths are expanded after the flake source is copied to
      # a store path which would get us read-only store paths.
      useOutOfStoreSymlinks =
        if builtins.hasAttr "useOutOfStoreSymlinks" config.home then
          config.home.useOutOfStoreSymlinks
        else
          false;
      dir = "${flakePath}/modules/features/ssh";
    in
    {
      home.file = {
        ".ssh/config".source =
          if useOutOfStoreSymlinks then config.lib.file.mkOutOfStoreSymlink "${dir}/config" else ./config;
      };
    };
}
