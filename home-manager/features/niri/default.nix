{ config, flakePath, lib, pkgs, ... }:

let
  # Out-of-store symlinks require absolute paths when using a flake config. This
  # is because relative paths are expanded after the flake source is copied to
  # a store path which would get us read-only store paths.
  dir = "${flakePath config}/home-manager/features/niri";
  niri-bin = "${pkgs.niri-stable}/bin/niri";
  colors = (import ./colors.nix).catppuccin-macchiato;
in
{
  imports = [
    ../rofi
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

  services.swayidle =
    let
      screen-blank-timeout = 5 * minutes;
      lock-after-blank-timeout = 15 * seconds;
      sleep-timeout = 45 * minutes;

      seconds = 1;
      minutes = 60 * seconds;

      loginctl = "${pkgs.systemd}/bin/loginctl";
      systemctl = "${pkgs.systemd}/bin/systemctl";
      playerctl = "${pkgs.playerctl}/bin/playerctl";
      swaylock = "${config.programs.swaylock.package}/bin/swaylock";
      _1password = "${pkgs._1password-gui}/bin/1password";

      lock-session = pkgs.writeShellScript "lock-session" ''
        ${swaylock} -f
        ${_1password} --lock
        ${niri-bin} msg action power-off-monitors
        ${playerctl} pause 2>/dev/null || true
      '';

      before-sleep = pkgs.writeShellScript "before-sleep" ''
        ${loginctl} lock-session
      '';
    in
    {
      enable = true;
      timeouts = [
        { timeout = screen-blank-timeout; command = "${niri-bin} msg action power-off-monitors"; }
        { timeout = screen-blank-timeout + lock-after-blank-timeout; command = "${loginctl} lock-session"; }
        { timeout = sleep-timeout; command = "${systemctl} suspend"; }
      ];
      events = [
        { event = "lock"; command = lock-session.outPath; }
        { event = "before-sleep"; command = before-sleep.outPath; }
      ];
      systemdTarget = "niri.service";
    };

  # OSD for volume, brightness changes
  services.swayosd.enable = true;
  systemd.user.services.swayosd = {
    # Adjust swayosd restart policy - it's failing due to too many restart
    # attempts when resuming from sleep
    Unit.StartLimitIntervalSec = 1;

    # Replace "graphical-session.target" so that this only starts when Niri starts.
    Install.WantedBy = [ "tray.target" ];
  };

  systemd.user.services.swaybg = {
    Unit = {
      Description = "Sets background color or image for Wayland compositors";
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      Slice = "background.slice";
      Type = "simple";
      Restart = "always";
      ExecStart = "${pkgs.swaybg}/bin/swaybg --color #${colors.surface0}";
    };
    Install.WantedBy = [ "niri.service" ];
  };
}
