{ config, pkgs, ... }:

let
  icon = pkgs.fetchurl {
    url = "https://avatars.githubusercontent.com/u/71840468";
    hash = "sha256-SbrM/eaZSDLzpfPnnqKZSMlDW+xizLs5+wVuXgCvosY=";
  };
in
{
  home.packages = with pkgs; [
    warp-terminal # custom package defined in `pkgs/`
  ];

  xdg.desktopEntries.warp-terminal = {
    name = "Warp Terminal";
    genericName = "Terminal";
    exec = "warp-terminal";
    terminal = false;
    inherit icon;
  };

  # Warp is not currently searching through XDG_DATA_DIRS, so we have to install
  # themes into XDG_DATA_HOME.
  home.file."${config.xdg.dataHome}/warp-terminal/themes" = {
    source = "${pkgs.catppuccin-warp-terminal}/share/warp-terminal/themes"; # custom package from `pkgs/`
    recursive = true;
  };
}
