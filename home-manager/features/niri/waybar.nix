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

      # Get v0.11 from unstable to get niri modules
      package = pkgs.unstable.waybar;

      settings = {
        mainBar = {
          layer = "top";
          position = "top";
          height = 30;

          modules-left = [ "custom/niri-workspaces" "niri/window" ];
          modules-center = [ "clock" "custom/notification" ];
          modules-right = [ "tray" ];

          clock = {
            format = "{:%a, %b %d  %H:%M}";
          } // notification-click-actions;

          "custom/niri-workspaces" =
            let
              jq-filter = ''
                sort_by(.idx) |
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

          tray.icon-size = 20;
        };
      };
      style = ./waybar.css;
      systemd.enable = true;
    };
}
