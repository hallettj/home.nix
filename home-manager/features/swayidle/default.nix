{
  config,
  lib,
  pkgs,
  ...
}:

let
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
      systemd
      playerctl
      procps # provides pgrep
      _1password-gui
    ];
    text = ''
      ${cfg.lock-screen-command}

      # Run the 1password lock command only if 1password is running. If it is
      # not running then the lock command will start it, which blocks this
      # script, which prevents swayidle from working until 1password is
      # closed.
      if pgrep -x 1password &>/dev/null; then
        1password --lock
      fi

      ${cfg.power-off-monitors-command or ""}
      playerctl pause 2>/dev/null || true
    '';
  };

  cfg = config.my-settings;
in
{
  options.my-settings = {
    fade-before-screen-lock-command = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = cfg.power-off-monitors-command;
      description = "Command to fade or blank the screen to warn that the screen lock is about to activate.";
    };
    power-off-monitors-command = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "Command to run after screen blank timeout to power off monitors.";
    };
    lock-screen-command = lib.mkOption {
      type = lib.types.str;
      default = "${lib.getExe config.programs.swaylock.package} -f";
      description = "Command to run a screen lock program, such as swaylock";
    };
  };

  config.home.packages = [ lock-session ]; # put script in $PATH for troubleshooting

  config.services.swayidle = {
    enable = true;
    timeouts = builtins.filter (x: x != { }) [
      (lib.optionalAttrs (cfg.fade-before-screen-lock-command != null) {
        timeout = screen-blank-timeout;
        command = cfg.fade-before-screen-lock-command;
      })
      {
        timeout = screen-blank-timeout + lock-after-blank-timeout;
        command = "${loginctl} lock-session";
      }
      {
        timeout = sleep-timeout;
        command = "${systemctl} suspend";
      }
    ];
    events = [
      {
        event = "lock";
        command = lib.getExe lock-session;
      }
      {
        event = "before-sleep";
        command = "${loginctl} lock-session";
      }
    ];
  };
}
