{
  config,
  flakePath,
  pkgs,
  ...
}:

let
  # Out-of-store symlinks require absolute paths when using a flake config. This
  # is because relative paths are expanded after the flake source is copied to
  # a store path which would get us read-only store paths.
  useOutOfStoreSymlinks =
    if builtins.hasAttr "useOutOfStoreSymlinks" config.home then
      config.home.useOutOfStoreSymlinks
    else
      false;
  dir = "${flakePath config}/home-manager/features/niri";
in
{
  imports = [
    ../rofi
    ./swayidle.nix
  ];

  # Nix packages configure Chrome and Electron apps to run in native Wayland
  # mode if this environment variable is set.
  home.sessionVariables.NIXOS_OZONE_WL = "1";

  home.packages = with pkgs; [
    (xwayland-satellite.override { withSystemd = false; }) # Niri automatically runs this when xwayland support is required
  ];

  xdg.configFile = {
    niri.source =
      if useOutOfStoreSymlinks then
        config.lib.file.mkOutOfStoreSymlink "${dir}/niri-config"
      else
        ./niri-config;
  };
}
