{ pkgs, ... }:

let
  niri-bin = "${pkgs.niri-stable}/bin/niri";
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
      settings = {
        mainBar = {
          layer = "top";
          position = "top";
          height = 30;

          modules-left = [ "custom/niri-workspaces" "custom/niri-focused-window" ];
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

          "custom/niri-workspaces" =
            let
              jq-filter = ''
                { 
                  text: map(if .is_active then " █ " else "┃" end) | join(""),
                  alt: .[] | select(.is_active) | (.name // .idx),
                  class: ["workspaces"] 
                }
              '';
              jq = "${pkgs.jq}/bin/jq";
              script = pkgs.writeShellScript "niri-workspaces" ''
                ${niri-bin} msg --json workspaces | ${jq} --unbuffered --compact-output '${jq-filter}'
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
}
