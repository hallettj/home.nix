{ config, ... }:

let
  terminal-width = if config.screen-type.aspect-ratio == "ultrawide" then "25%" else "33%";
  neovide-width = if config.screen-type.aspect-ratio == "ultrawide" then "75%" else "66%";

  cycle-width-steps =
    if config.screen-type.aspect-ratio == "ultrawide" then
      [ (1 * quarters) (1 * thirds) half (2 * thirds) (3 * quarters) ]
    else
      [ (1 * thirds) half (2 * thirds) ];

  thirds = 1 / 3.0;
  quarters = 1 / 4.0;
  half = 1 / 2.0;
in
{
  gnomeExtensions.paperwm = {
    enable = true;

    inherit cycle-width-steps;
    horizontal-margin = 8;
    show-window-position-bar = true;
    topbar-follow-focus = true;
    vertical-margin = 2;
    vertical-margin-bottom = 2;
    window-gap = 8;

    winprops = [
      { wm-class = "Slack"; scratch-layer = true; }
      { wm-class = "chrome-cinhimbnkkaeohfgghhklpknlkffjgod-Default"; scratch-layer = true; }
      { wm-class = "kitty"; preferred-width = terminal-width; }
      { wm-class = "dev.warp.Warp"; preferred-width = terminal-width; }
      { wm-class = "neovide"; preferred-width = neovide-width; }
    ];

    workspaces = [
      { name = "Home"; id = "f7bf4f04-df01-49d4-90d9-ac80b7e9d3b2"; }
      { name = "Work"; id = "d13c7071-e870-4014-92a4-709476e62916"; color = "rgb(73,64,102)"; }
      { name = "IBNU"; id = "7c060a9f-4e62-40c6-9d78-278d8d959e2c"; }
      { name = "Games"; id = "e47bab66-3212-415e-bc03-cd4cd6cef712"; }
    ];

    keybindings = {
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
  };

  dconf.settings = {
    "org/gnome/shell/keybindings" = {
      focus-active-notification = [ "<Control><Super>n" ]; # the default conflicts with my switch-right paperwm binding
    };
    "org/gnome/desktop/wm/keybindings" = {
      minimize = [ ]; # The default conflicts with my switch-left paperwm binding
    };
  };
}
