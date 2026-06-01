# Scrolling window manager

{
  config,
  inputs,
  self,
  ...
}:

let
  flakePath = config.flakePath;
  niri = pkgs: pkgs.niri;
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

  flake.modules.nixos.niri =
    { pkgs, ... }:
    {
      programs.niri.enable = true;
      programs.niri.package = niri pkgs;

      # Copied from niri-flake. Polkit allows, for example, superuser access for gparted
      security.polkit.enable = true;
      services.gnome.gnome-keyring.enable = true;
      systemd.user.services.niri-flake-polkit = {
        description = "PolicyKit Authentication Agent for niri";
        wantedBy = [ "niri.service" ];
        after = [ "graphical-session.target" ];
        partOf = [ "graphical-session.target" ];
        serviceConfig = {
          Type = "simple";
          ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
          Restart = "on-failure";
          RestartSec = 1;
          TimeoutStopSec = 10;
        };
      };
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

      programs.niri.package = niri pkgs;

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
      services.swayidle.systemdTargets = [ "niri.service" ];
      # };
    };
}
