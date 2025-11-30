{ pkgs, ... }:

let
  colors = (import ./colors.nix).catppuccin-macchiato;
in
{
  programs.waybar =
    let
      notification-click-actions = {
        on-click = "swaync-client -t -sw";
        on-click-right = "swaync-client -d -sw";
      };
    in
    {
      enable = true;

      package = pkgs.waybar;

      settings = {
        mainBar = {
          layer = "top";
          position = "top";
          height = 30;

          modules-left = [ "ext/workspaces" "niri/window" ];
          modules-center = [ "clock" "custom/notification" ];
          modules-right = [ "pulseaudio" "tray" ];

          clock = {
            format = "{:%a, %b %d  %H:%M}";
          } // notification-click-actions;

          "ext/workspaces" = {
            format = "{icon}";
            on-click = "activate";
            format-icons = {
              default = "┃";
              urgent = "┃";
              active = " █ ";
            };
          };

          "niri/window" = {
            format = "{app_id} — {title}";
          };

          "custom/notification" = {
            tooltip = false;
            format = "{icon}";
            format-icons = with colors; {
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

          pulseaudio = {
            format = "{volume}% {icon}";
            format-bluetooth = "{volume}% {icon}";
            format-muted = "";
            format-icons = {
              "alsa_output.usb-Kingston_HyperX_Virtual_Surround_Sound_00000000-00.analog-stereo" = ""; # HyperX headphone controller
              "alsa_output.pci-0000_0c_00.1.hdmi-stereo" = ""; # Navi 31
              "alsa_output.pci-0000_0e_00.4.iec958-stereo" = ""; # Starship/Matisse
              headphone = "";
              hands-free = "";
              headset = "";
              phone = "";
              phone-muted = "";
              portable = "";
              car = "";
              default = [ "" "" ];
            };
            scroll-step = 1;
            on-click = "pavucontrol";
            ignored-sinks = [ "Easy Effects Sink" ];
          };

          tray.icon-size = 20;
        };
      };
      style = ./waybar.css;
      systemd.enable = true;
    };
}
