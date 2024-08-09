{ config, pkgs, ... }:

let
  niri-bin = "${pkgs.niri-stable}/bin/niri";
in
{
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

  systemd.user.services.swayidle.Unit.After = "niri.service";
}