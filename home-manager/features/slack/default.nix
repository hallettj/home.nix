{ pkgs, ... }:

let
  package = pkgs.slack;
in
{
  home.packages = [ package ];

  # Custom desktop entry enables Ozone for Wayland support, and sets
  # XDG_CURRENT_DESKTOP to work with Waybar's system tray
  xdg.desktopEntries.slack = {
    name = "Slack";
    comment = "Slack Desktop";
    genericName = "Slack Client for Linux";
    exec = "env XDG_CURRENT_DESKTOP=Unity ${pkgs.slack}/bin/slack --enable-features=UseOzonePlatform --ozone-platform=wayland -s %U";
    icon = "slack";
    type = "Application";
    startupNotify = true;
    categories = [ "GNOME" "GTK" "Network" "InstantMessaging" ];
    mimeType = [ "x-scheme-handler/slack" ];
    settings = {
      StartupWMClass = "Slack";
    };
  };
}
