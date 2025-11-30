{ config, lib, pkgs, ... }:

let
  colors = (import ./colors.nix).catppuccin-macchiato;
  niri-bin = "${pkgs.niri-stable}/bin/niri";
  loginctl = "${pkgs.systemd}/bin/loginctl";
  systemctl = "${pkgs.systemd}/bin/systemctl";

  screen-blank-timeout = 5 * minutes;
  lock-after-blank-timeout = 15 * seconds;
  sleep-timeout = 45 * minutes;

  seconds = 1;
  minutes = 60 * seconds;

  lock-session = pkgs.writeShellApplication {
    name = "lock-session";
    runtimeInputs = with pkgs; [
      niri-stable
      systemd
      playerctl
      config.programs.swaylock.package
      _1password-gui
    ];
    text = ''
      swaylock -f

      # Run the 1password lock command only if 1password is running. If it is
      # not running then the lock command will start it, which blocks this
      # script, which prevents swayidle from working until 1password is
      # closed.
      if pgrep 1password; then
        1password --lock
      fi

      niri msg action power-off-monitors
      playerctl pause 2>/dev/null || true
    '';
  };
in
{
  home.packages = [ lock-session ]; # put script in $PATH for troubleshooting

  services.swayidle = {
    enable = true;
    timeouts = [
      { timeout = screen-blank-timeout; command = "${niri-bin} msg action power-off-monitors"; }
      { timeout = screen-blank-timeout + lock-after-blank-timeout; command = "${loginctl} lock-session"; }
      { timeout = sleep-timeout; command = "${systemctl} suspend"; }
    ];
    events = [
      { event = "lock"; command = lib.getExe lock-session; }
      { event = "before-sleep"; command = "${loginctl} lock-session"; }
    ];
    systemdTarget = "niri.service";
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

}
