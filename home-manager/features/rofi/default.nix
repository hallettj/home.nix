{ pkgs, ... }:

# Run programs or switch to open windows
let
  rofi = pkgs.rofi.override {
    plugins = [ ];
    rofi-unwrapped = pkgs.rofi-unwrapped.override {
      waylandSupport = true;
      x11Support = false;
    };
  };
in
{
  home.packages = [ rofi ];
  xdg.configFile."rofi/config.rasi".source = ./config.rasi;
}
