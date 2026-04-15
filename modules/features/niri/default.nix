# Scrolling window manager

{
  config,
  inputs,
  self,
  ...
}:

let
  flakePath = config.flakePath;
in
{
  flake-file.inputs = {
    # Fork of niri-flake with fix from PR #1397
    # https://github.com/sodiboo/niri-flake/pull/1397
    niri-flake = {
      url = "github:LuckShiba/niri-flake/includes";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
      inputs.nixpkgs-stable.follows = "nixpkgs";
    };
  };

  flake.modules.nixos.niri = {
    programs.niri.enable = true;
  };

  flake.modules.homeManager.niri =
    {
      config,
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
      dir = "${flakePath}/modules/features/niri";
    in
    {
      imports = with self.modules.homeManager; [
        inputs.niri-flake.homeModules.niri
        rofi
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
    };
}
