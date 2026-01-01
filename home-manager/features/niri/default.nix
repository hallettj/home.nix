{
  config,
  flakePath,
  inputs,
  lib,
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
    inputs.niri-flake.homeModules.config
    ../rofi
  ];

  programs.niri.package = pkgs.niri;

  programs.niri.settings = {
    includes = lib.mkAfter [
      # Changes made to this kdl file are hot-reloaded when using out-of-store
      # symlinks.
      (if useOutOfStoreSymlinks then "${dir}/config.kdl" else ./config.kdl)
    ];
  };

  # Nix packages configure Chrome and Electron apps to run in native Wayland
  # mode if this environment variable is set.
  home.sessionVariables.NIXOS_OZONE_WL = "1";

  home.packages = with pkgs; [
    (xwayland-satellite.override { withSystemd = false; }) # Niri automatically runs this when xwayland support is required
  ];

  # Referenced in my swayidle module
  my-settings.power-off-monitors-command = "${lib.getExe pkgs.niri} msg action power-off-monitors";
  services.swayidle.systemdTarget = "niri.service";
  # };
}
