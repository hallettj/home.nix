flakeParts:

let
  flakePath = flakeParts.config.flakePath;
in
{
  flake.modules.homeManager.kitty =
    { config, pkgs, ... }:

    let
      # Out-of-store symlinks require absolute paths when using a flake config. This
      # is because relative paths are expanded after the flake source is copied to
      # a store path which would get us read-only store paths.
      useOutOfStoreSymlinks =
        if builtins.hasAttr "useOutOfStoreSymlinks" config.home then
          config.home.useOutOfStoreSymlinks
        else
          false;
      dir = "${flakePath}/modules/features/kitty";
    in
    {
      programs.kitty = {
        enable = true;
        settings = {
          include = if useOutOfStoreSymlinks then "${dir}/kitty.conf" else ./kitty.conf;
        };
      };

      home.packages = with pkgs; [
        kitty-themes
      ];
    };
}
