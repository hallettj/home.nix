{ config, flakePath, pkgs, ... }:

let
  # Out-of-store symlinks require absolute paths when using a flake config. This
  # is because relative paths are expanded after the flake source is copied to
  # a store path which would get us read-only store paths.
  dir = "${flakePath config}/home-manager/features/niri";

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

  # Increase font sizes - it's cleaner than applying a display scaling factor.
  dconf.settings."org/gnome/desktop/interface" = {
    text-scaling-factor = 1.25;
  };

  home.packages = with pkgs; [
    playerctl # for play-pause key bind
    swaybg # set background
    swayidle
    swaylock
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

          modules-left = [ ];
          modules-center = [ "clock" "custom/notification" ];
          modules-right = [ "tray" ];

          clock = {
            format = "{:%a, %b %d  %H:%M}";
          } // notification-click-actions;

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
        };
      };
      style = ./waybar.css;
      systemd = {
        enable = true;
        target = "niri.target";
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
}
