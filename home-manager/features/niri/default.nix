{ config, flakePath, pkgs, ... }:

let
  # Out-of-store symlinks require absolute paths when using a flake config. This
  # is because relative paths are expanded after the flake source is copied to
  # a store path which would get us read-only store paths.
  dir = "${flakePath config}/home-manager/features/niri";

  niri-bin = "${pkgs.niri-stable}/bin/niri";

  catppuccin-macchiato = {
    rosewater = "f4dbd6";
    flamingo = "f0c6c6";
    pink = "f5bde6";
    mauve = "c6a0f6";
    red = "ed8796";
    maroon = "ee99a0";
    peach = "f5a97f";
    yellow = "eed49f";
    green = "a6da95";
    teal = "8bd5ca";
    sky = "91d7e3";
    sapphire = "7dc4e4";
    blue = "8aadf4";
    lavender = "b7bdf8";
    text = "cad3f5";
    subtext1 = "b8c0e0";
    subtext0 = "a5adcb";
    overlay2 = "939ab7";
    overlay1 = "8087a2";
    overlay0 = "6e738d";
    surface2 = "5b6078";
    surface1 = "494d64";
    surface0 = "363a4f";
    base = "24273a";
    mantle = "1e2030";
    crust = "181926";
  };
in
{
  # Nix packages configure Chrome and Electron apps to run in native Wayland
  # mode if this environment variable is set.
  home.sessionVariables.NIXOS_OZONE_WL = "1";

  home.packages = with pkgs; [
    cage # run X11 apps
    (pkgs.callPackage ./enpass-in-xwayland.nix { })
    playerctl # for play-pause key bind
    swaynotificationcenter
  ];

  xdg.configFile = {
    niri.source = config.lib.file.mkOutOfStoreSymlink "${dir}/niri-config";
    swaync.source = config.lib.file.mkOutOfStoreSymlink "${dir}/swaync";
  };

  # Run programs or switch to open windows
  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
    font = "mono 18"; # columns don't align with proportional fonts
    terminal = "${config.programs.kitty.package}/bin/kitty";
    extraConfig = {
      show-icons = true;
    };
  };

  programs.swaylock = {
    enable = true;
    settings = with catppuccin-macchiato; {
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

  programs.waybar =
    let
      notification-click-actions = {
        on-click = "swaync-client -t -sw";
        on-click-right = "swaync-client -d -sw";
      };
    in
    {
      enable = true;
      settings = {
        mainBar = {
          layer = "top";
          position = "top";
          height = 30;

          modules-left = [ "custom/niri-focused-window" ];
          modules-center = [ "clock" "custom/notification" ];
          modules-right = [ "tray" "network" ];

          clock = {
            format = "{:%a, %b %d  %H:%M}";
          } // notification-click-actions;

          "custom/niri-focused-window" =
            let
              jq-filter = ''
                if . then
                  { text: "\(.app_id) — \(.title)", alt: .app_id, class: ["focused-window"] }
                else
                  { text: "", alt: "", class: ["focused-window"] }
                end
              '';
              jq = "${pkgs.jq}/bin/jq";
              script = pkgs.writeShellScript "niri-focused-window" ''
                ${niri-bin} msg --json focused-window | ${jq} --unbuffered --compact-output '${jq-filter}'
              '';
            in
            {
              tooltip = false;
              return-type = "json";
              exec = script.outPath;
              interval = 1;
            };

          "custom/notification" = {
            tooltip = false;
            format = "{icon}";
            format-icons = with catppuccin-macchiato; {
              notification = "<span foreground='#${maroon}'></span>";
              none = "";
              dnd-notification = "<span foreground='#${maroon}'></span>";
              dnd-none = "";
              inhibited-notification = "<span foreground='#${maroon}'></span>";
              inhibited-none = "";
              dnd-inhibited-notification = "<span foreground='#${maroon}'></span>";
              dnd-inhibited-none = "";
            };
            return-type = "json";
            exec-if = "which swaync-client";
            exec = "swaync-client -swb";
            escape = true;
          } // notification-click-actions;

          tray.icon-size = 20;

          network = {
            format-wifi = "{icon}";
            format-ethernet = "󰈀";
            format-disconnected = "󰤮"; # An empty format will hide the module.
            tooltip-format-wifi = "{ifname} [{essid}] {ipaddr}/{cidr} ({signalStrength}%)";
            tooltip-format-ethernet = "{ifname} {ipaddr}/{cidr}";
            tooltip-format-disconnected = "{ifname} disconnected";
            format-icons = [ "󰤯" "󰤟" "󰤢" "󰤥" "󰤨" ];
            max-length = 50;
          } // (
            let
              rofi-wifi-menu = pkgs.fetchFromGitHub {
                owner = "ericmurphyxyz";
                repo = "rofi-wifi-menu";
                rev = "d6debde6e302f68d8235ced690d12719124ff18e";
                hash = "sha256-H+vBRdGcSDMKGLHhPB7imV148O8GRTMj1tZ+PLQUVG4=";
              };
            in
            {
              on-click = "${pkgs.bash}/bin/bash ${rofi-wifi-menu}/rofi-wifi-menu.sh";
              on-click-right = "${pkgs.networkmanagerapplet}/bin/nm-connection-editor";
            }
          );
        };
      };
      style = ./waybar.css;
      systemd = {
        enable = true;
        target = "niri.service";
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

      lock-session = pkgs.writeShellScript "lock-session" ''
        ${swaylock} -f
        ${niri-bin} msg action power-off-monitors
        ${playerctl} pause
      '';

      before-sleep = pkgs.writeShellScript "before-sleep" ''
        ${loginctl} lock-session
        ${playerctl} pause
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

  systemd.user.services.swaybg = {
    Unit = {
      Description = "Sets background color or image for Wayland compositors";
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      Type = "simple";
      Restart = "always";
      ExecStart = "${pkgs.swaybg}/bin/swaybg --color #363a4f"; # "Surface0" from Catppuccin Macchiato theme
    };
    Install.WantedBy = [ "niri.service" ];
  };
}
