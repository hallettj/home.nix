{ pkgs, ... }:

{
  home.packages = with pkgs; [
    git-butler # custom package defined in `pkgs/`
  ];

  xdg.desktopEntries.git-butler = {
    name = "GitButler";
    categories = [ "Development" ];
    exec = "git-butler";
    terminal = false;
    type = "Application";
    icon = "${pkgs.git-butler.appimage_content}/usr/share/icons/hicolor/128x128/apps/git-butler.png";
  };
}
