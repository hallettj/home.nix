{ config, pkgs, ... }:

# Run programs or switch to open windows
{
  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
    font = "mono 18"; # columns don't align with proportional fonts
    terminal = "${config.programs.kitty.package}/bin/kitty";
    extraConfig = {
      show-icons = true;
    };
  };
}
