{ config, pkgs, ... }:

{
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      #enable-hot-corners = false;
    };

    # Settings that PaperWM prefers
    "org/gnome/mutter" = {
      workspaces-only-on-primary = false;
      edge-tiling = false;
      attach-modal-dialogs = false;
    };

    "org/gnome/shell" = {
      disable-user-extensions = false;
      enabled-extensions = [
        "advanced-alt-tab@G-dH.github.com"
        "appindicatorsupport@rgcjonas.gmail.com"
        "gtktitlebar@velitasali.github.io"
        "paperwm@hedning:matrix.org"
        "runcat@kolesnikov.se"
      ];
    };
  };

  home.packages = with pkgs.gnomeExtensions; [
    advanced-alttab-window-switcher
    appindicator
    paperwm
    gtk-title-bar
    runcat
  ];
}
