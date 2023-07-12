{ lib, pkgs, ... }:

let
  paperwmWorkspaces =
    [
      { name = "Home"; id = "f7bf4f04-df01-49d4-90d9-ac80b7e9d3b2"; }
      { name = "Work"; id = "d13c7071-e870-4014-92a4-709476e62916"; color = "rgb(73,64,102)"; }
      { name = "IBNU"; id = "7c060a9f-4e62-40c6-9d78-278d8d959e2c"; }
      { name = "Games"; id = "e47bab66-3212-415e-bc03-cd4cd6cef712"; }
    ];
in
{
  imports = [ ./gnome-extensions.nix ];

  config.home.packages = with pkgs; [
    gnome.gnome-tweaks
  ];

  config.gnomeExtensions = {
    enable = true;
    enabledExtensionUuids = [
      "advanced-alt-tab@G-dH.github.com"
      "appindicatorsupport@rgcjonas.gmail.com"
      "gtktitlebar@velitasali.github.io"
      "horizontal-workspace-indicator@tty2.io"
      "paperwm@paperwm.github.com"
      "runcat@kolesnikov.se"
    ];
    packages = [
      (pkgs.callPackage ./paperwm.nix { })
    ];
  };

  config.dconf.settings = {
    "org/gnome/desktop/datetime" = { automatic-timezone = true; };
    "org/gnome/system/location" = { enabled = true; }; # Location required for automatic time zone

    "org/gnome/desktop/calendar".show-weekdate = true;
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
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
        "terminate:ctrl_alt_bksp"
      ];
    };

    # Settings that PaperWM prefers
    "org/gnome/mutter" = {
      workspaces-only-on-primary = false;
      edge-tiling = false;
      attach-modal-dialogs = false;
    };

    # Fractional scaling
    "org/gnome/mutter" = {
      experimental-features = [ "scale-monitor-framebuffer" ]; # fractional scaling
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

    "org/gnome/shell/extensions/paperwm" = {
      cycle-width-steps = [ 0.25 0.33329999999999999 0.5 0.66659999999999997 0.75 ];
      horizontal-margin = 8;
      show-window-position-bar = true;
      topbar-follow-focus = true;
      vertical-margin-bottom = 2;
      window-gap = 8;
      winprops = [
        ''{"wm_class":"kitty","preferredWidth":"25%"}''
        ''{"wm_class":"neovide","preferredWidth":"75%"}''
        ''{"wm_class":"Slack","scratch_layer":true}''
        ''{"wm_class":"chrome-cinhimbnkkaeohfgghhklpknlkffjgod-Default","scratch_layer":true}''
      ];
    };

    "org/gnome/shell/extensions/paperwm/keybindings" = {
      center-horizontally = [ "<Super>m" ];
      live-alt-tab = [ "" ];
      move-down = [ "<Shift><Super>Down" "<Shift><Super>t" ];
      move-down-workspace = [ "<Shift><Super>Page_Down" ];
      move-left = [ "<Shift><Super>Left" "<Shift><Super>h" ];
      move-monitor-above = [ "" ];
      move-monitor-below = [ "" ];
      move-monitor-left = [ "" ];
      move-monitor-right = [ "" ];
      move-previous-workspace = [ "" ];
      move-previous-workspace-backward = [ "" ];
      move-right = [ "<Shift><Super>Right" "<Shift><Super>n" ];
      move-up = [ "<Shift><Super>Up" "<Shift><Super>c" ];
      move-up-workspace = [ "<Shift><Super>Page_Up" ];
      new-window = [ "<Super>Return" ];
      previous-workspace = [ "" ];
      previous-workspace-backward = [ "" ];
      switch-down = [ "<Super>Down" "<Super>t" ];
      switch-focus-mode = [ "<Shift><Super>m" ];
      switch-left = [ "<Super>Left" "<Super>h" ];
      switch-monitor-above = [ "" ];
      switch-monitor-below = [ "" ];
      switch-monitor-left = [ "" ];
      switch-monitor-right = [ "" ];
      switch-right = [ "<Super>Right" "<Super>n" ];
      switch-up = [ "<Super>Up" "<Super>c" ];
      take-window = [ "<Super>b" ];
      toggle-scratch = [ "<Shift><Super>quotedbl" ]; # move window into or out of scratch layer
      toggle-scratch-layer = [ "<Control><Super>apostrophe" ];
      toggle-scratch-window = [ "<Super>apostrophe" ];
    };

    "org/gnome/shell/keybindings" = {
      focus-active-notification = [ "<Control><Super>n" ];
      switch-to-application-1 = [ "" ];
      switch-to-application-2 = [ "" ];
      switch-to-application-3 = [ "" ];
      switch-to-application-4 = [ "" ];
      switch-to-application-5 = [ "" ];
      switch-to-application-6 = [ "" ];
      switch-to-application-7 = [ "" ];
      switch-to-application-8 = [ "" ];
      switch-to-application-9 = [ "" ];
      toggle-overview = [ "<Super>v" ];
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

    "org/gnome/shell/extensions/horizontal-workspace-indicator" = {
      icons-style = "lines";
    };

    "org/gnome/shell/extensions/runcat" = {
      displaying-items = "character-only";
      idle-threshold = 10;
    };

    "org/gnome/GWeather" = {
      temperature-unit = "centigrade";
    };

    "org/gnome/shell/extensions/paperwm/workspaces" = {
      list = builtins.map (w: w.id) paperwmWorkspaces;
    };
  } // (
    # Transform the `paperwmWorkspaces` list into a set of dconf values of the
    # form,
    #
    #     "d13c7071-e870-4014-92a4-709476e62916" = {
    #       name = "Work";
    #       index = 1;
    #       color = "rgb(73,64,102)";
    #     };
    #
    builtins.listToAttrs
      (pkgs.lib.lists.imap0
        (index: workspace: {
          name = "org/gnome/shell/extensions/paperwm/workspaces/${workspace.id}";
          value = builtins.removeAttrs workspace [ "id" ] // { index = index; };
        })
        paperwmWorkspaces)
  );
}
