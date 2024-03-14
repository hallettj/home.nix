{ pkgs, ... }:

let
  package = pkgs.unstable.obsidian;
in
{
  home.packages = [ package ];

  # Custom desktop entry enables Ozone for Wayland support
  xdg.desktopEntries.obsidian = {
    name = "Obsidian";
    categories = [ "Office" ];
    comment = "Knowledge base";
    exec = "${package}/bin/obsidian --enable-features=UseOzonePlatform --ozone-platform=wayland %u";
    icon = "obsidian";
    type = "Application";
    mimeType = [ "x-scheme-handler/obsidian" ];
    settings = {
      Version = "1.4";
    };
  };
}
