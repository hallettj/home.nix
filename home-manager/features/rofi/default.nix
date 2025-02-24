{ config, pkgs, ... }:

# Run programs or switch to open windows
{
  home.packages = with pkgs; [ rofi-wayland ];
  xdg.configFile."rofi/config.rasi".source = ./config.rasi;
}
