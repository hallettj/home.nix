{ config, flakePath, lib, outputs, pkgs, ... }:

let
  # Out-of-store symlinks require absolute paths when using a flake config. This
  # is because relative paths are expanded after the flake source is copied to
  # a store path which would get us read-only store paths.
  useOutOfStoreSymlinks =
    if builtins.hasAttr "useOutOfStoreSymlinks" config.home
    then config.home.useOutOfStoreSymlinks
    else false;
  dir = "${flakePath config}/home-manager/features/gnome";
in
{
  imports = [
    outputs.homeManagerModules.gnomeExtensions
    ./paperwm.nix
  ];

  home.packages = with pkgs; [
    gnome-tweaks
  ];

  gnomeExtensions = {
    enable = true;
    enabledExtensionUuids = [
      "advanced-alt-tab@G-dH.github.com"
      "appindicatorsupport@rgcjonas.gmail.com"
      "runcat@kolesnikov.se"
    ];
  };

  xdg.configFile."mimeapps.list".source =
    if useOutOfStoreSymlinks
    then config.lib.file.mkOutOfStoreSymlink "${dir}/mimeapps.list"
    else ./mimeapps.list;

  dconf.settings = {
    "org/gnome/desktop/datetime" = { automatic-timezone = false; };
    "org/gnome/system/location" = { enabled = false; }; # Location required for automatic time zone

    "org/gnome/desktop/calendar".show-weekdate = true;
    "org/gnome/desktop/interface" = {
      font-antialiasing = "grayscale";
      font-hinting = "slight";
    };

    "org/gnome/desktop/input-sources" = {
      sources = [
        (lib.hm.gvariant.mkTuple [ "xkb" "us" ])
        (lib.hm.gvariant.mkTuple [ "xkb" "us+dvorak" ])
      ];
      xkb-options = [
        "caps:ctrl_modifier"
        "compose:menu"
        "terminate:ctrl_alt_bksp"
      ];
    };

    "org/gnome/settings-daemon/plugins/media-keys" = {
      "screensaver" = [ "<Control><Super>l" ]; # lock screen
      # Makes media keys change volume by a smaller increment
      "volume-step" = 2;
    };

    "org/gnome/shell" = {
      favorite-apps = [
        "org.gnome.Nautilus.desktop"
        "org.gnome.Software.desktop"
        "firefox.desktop"
        "neovide.desktop"
        "md.obsidian.Obsidian.desktop"
        "kitty.desktop"
        "chrome-cinhimbnkkaeohfgghhklpknlkffjgod-Default.desktop" # TODO: match up with chrome apps in home-manager config
      ];
    };

    "org/gnome/shell/keybindings" = {
      switch-to-application-1 = [ "" ];
      switch-to-application-2 = [ "" ];
      switch-to-application-3 = [ "" ];
      switch-to-application-4 = [ "" ];
      switch-to-application-5 = [ "" ];
      switch-to-application-6 = [ "" ];
      switch-to-application-7 = [ "" ];
      switch-to-application-8 = [ "" ];
      switch-to-application-9 = [ "" ];
      toggle-overview = [ "<Super>v" ]; # <Super> is taken by AATS
    };

    "org/gnome/shell/extensions/advanced-alt-tab-window-switcher" = {
      app-switcher-popup-fav-apps = false;
      app-switcher-popup-filter = 2;
      app-switcher-popup-include-show-apps-icon = false;
      app-switcher-popup-search-pref-running = true;
      enable-super = false;
      hot-edge-position = 0;
      super-double-press-action = 3;
      super-key-mode = 3;
      switcher-popup-hot-keys = false;
      switcher-popup-interactive-indicators = true;
      switcher-popup-position = 3;
      switcher-popup-timeout = 0;
      switcher-ws-thumbnails = 2;
      win-switcher-popup-filter = 2;
      win-switcher-popup-order = 1;
    };

    "org/gnome/shell/extensions/gtktitlebar" = {
      hide-window-titlebars = "always";
      restrict-to-primary-screen = false;
    };

    "org/gnome/shell/extensions/runcat" = {
      displaying-items = "character-only";
      idle-threshold = 10;
    };

    "org/gnome/GWeather" = {
      temperature-unit = "centigrade";
    };
  };
}
