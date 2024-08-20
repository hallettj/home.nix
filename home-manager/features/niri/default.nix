{ config, flakePath, lib, pkgs, ... }:

let
  # Out-of-store symlinks require absolute paths when using a flake config. This
  # is because relative paths are expanded after the flake source is copied to
  # a store path which would get us read-only store paths.
  dir = "${flakePath config}/home-manager/features/niri";
  colors = (import ./colors.nix).catppuccin-macchiato;
in
{
  imports = [
    ../rofi
    ./swayidle.nix
    ./waybar.nix
    ./xwayland-satellite.nix
  ];

  # Nix packages configure Chrome and Electron apps to run in native Wayland
  # mode if this environment variable is set.
  home.sessionVariables.NIXOS_OZONE_WL = "1";

  home.packages = with pkgs; [
    playerctl # for play-pause key bind
    swaynotificationcenter
  ];

  xdg.configFile = {
    niri.source = config.lib.file.mkOutOfStoreSymlink "${dir}/niri-config";
    swaync.source = config.lib.file.mkOutOfStoreSymlink "${dir}/swaync";
  };

  programs.swaylock = {
    enable = true;
    settings = with colors; {
      color = mantle;
      font-size = 48;
      font = "Cantarell";

      indicator-radius = 160;
      indicator-thickness = 20;

      ring-color = teal;
      inside-color = mantle;
      text-color = text;

      key-hl-color = green;
      bs-hl-color = maroon;

      ring-clear-color = peach;
      inside-clear-color = peach;
      text-clear-color = mantle;

      # "ver" is short for "Verifying"
      ring-ver-color = mauve;
      inside-ver-color = mauve;
      text-ver-color = mantle;

      ring-wrong-color = red;
      inside-wrong-color = red;
      text-wrong-color = mantle;

      line-color = crust;
      separator-color = crust;

      ignore-empty-password = true;
      indicator-idle-visible = false;
      show-failed-attempts = true;
    };
  };

  services.blueman-applet.enable = true;
  systemd.user.services.blueman-applet.Install = lib.mkForce {
    # Replace "graphical-session.target" so that this only starts when Niri starts.
    WantedBy = [ "tray.target" ];
  };

  services.network-manager-applet.enable = true;
  systemd.user.services.network-manager-applet.Install = lib.mkForce {
    # Replace "graphical-session.target" so that this only starts when Niri starts.
    WantedBy = [ "tray.target" ];
  };

  # Some services, like blueman-applet, require a `tray` target. Typically Home
  # Manager sets this target in WM modules, but it's not set up for Niri yet.
  systemd.user.targets.tray = {
    Unit = {
      Description = "Target for apps that want to start minimized to the system tray";
      After = [ "niri.service" ];
    };
    Install = {
      WantedBy = [ "niri.service" ];
    };
  };

  # Use Gnome Keyring as SSH agent
  services.gnome-keyring = {
    enable = true;
    components = [ "pkcs11" "secrets" "ssh" ];
  };
  home.sessionVariables.SSH_AUTH_SOCK = "$XDG_RUNTIME_DIR/keyring/ssh";


  # OSD for volume, brightness changes
  services.swayosd.enable = true;
  systemd.user.services.swayosd = {
    # Adjust swayosd restart policy - it's failing due to too many restart
    # attempts when resuming from sleep
    Unit.StartLimitIntervalSec = lib.mkForce 1;

    # Replace "graphical-session.target" so that this only starts when Niri starts.
    Install.WantedBy = [ "tray.target" ];
  };
}
