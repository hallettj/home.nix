{
  config,
  flakePath,
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

  cfg = config.programs.niri;
in
{
  imports = [
    ../rofi
  ];

  options = {
    programs.niri.extraConfig = lib.mkOption {
      type = lib.types.lines;
      default = "";
      description = "Additional configuration to add to ~/.config/niri/config.kdl";
    };
  };

  config = {
    # Nix packages configure Chrome and Electron apps to run in native Wayland
    # mode if this environment variable is set.
    home.sessionVariables.NIXOS_OZONE_WL = "1";

    home.packages = with pkgs; [
      (xwayland-satellite.override { withSystemd = false; }) # Niri automatically runs this when xwayland support is required
    ];

    programs.niri.extraConfig = lib.mkMerge [
      # Include kdl file so that I can still get live config reloading by
      # editing that file. I want this to come after configuration from Nix by
      # default, so I'm setting an order that is higher than the default (1000),
      # but lower than lib.mkAfter (1500).
      (lib.mkOrder 1400 ''
        include "${if useOutOfStoreSymlinks then "${dir}/config.kdl" else ./config.kdl}"
      '')
    ];

    xdg.configFile."niri/config.kdl".text = cfg.extraConfig;

    # Referenced in my swayidle module
    my-settings.power-off-monitors-command = "${lib.getExe pkgs.niri} msg action power-off-monitors";
    services.swayidle.systemdTarget = "niri.service";
  };
}
