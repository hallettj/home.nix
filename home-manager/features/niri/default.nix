{ config, flakePath, ... }:

let
  # Out-of-store symlinks require absolute paths when using a flake config. This
  # is because relative paths are expanded after the flake source is copied to
  # a store path which would get us read-only store paths.
  dir = "${flakePath config}/home-manager/features/niri";
in
{
  xdg.configFile.niri = {
    source = config.lib.file.mkOutOfStoreSymlink "${dir}/niri-config";
  };

  programs.fuzzel = {
    enable = true;
    settings.main = {
      terminal = "${config.programs.kitty.package}/bin/kitty";
    };
  };

  programs.swaylock = {
    enable = true;
    settings = {
      color = "000000";
      font-size = 24;
      indicator-idle-visible = false;
      indicator-radius = 100;
      line-color = "ffffff";
      show-failed-attempts = true;
    };
  };

  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 30;
        # output = [
        #   "eDP-1"
        #   "HDMI-A-1"
        # ];
        modules-left = [ "sway/workspaces" "sway/mode" "wlr/taskbar" ];
        modules-center = [ "sway/window" "custom/hello-from-waybar" ];
        modules-right = [ "mpd" "custom/mymodule#with-css-id" "temperature" ];

        # "sway/workspaces" = {
        #   disable-scroll = true;
        #   all-outputs = true;
        # };
      };
    };
    style = ./waybar.css;
    systemd = {
      enable = true;
      target = "niri.target";
    };
  };
}
