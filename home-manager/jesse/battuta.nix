{
  outputs,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    outputs.homeManagerModules.screen-type
    outputs.homeManagerModules.useOutOfStoreSymlinks
    ../common.nix
    ../profiles/desktop
  ];

  my-settings = {
    show-battery-status = true;
    show-brightness = true;
    defaultWallpaper =
      (pkgs.fetchurl {
        url = "https://w.wallhaven.cc/full/x6/wallhaven-x6l5vl.jpg"; # Source: https://wallhaven.cc/w/x6l5vl
        hash = "sha256-g2XGek4OqeLbOPAo146Iyfr/AJmQYmYuJ5dD0tVqqbg=";
      }).outPath;
  };

  # Increase font sizes - it's cleaner than applying a display scaling factor.
  dconf.settings."org/gnome/desktop/interface" = {
    text-scaling-factor = 2.0;
  };

  programs.kitty.extraConfig = ''
    font_size 20.0
  '';

  programs.waybar.settings.mainBar = {
    # Add battery module to waybar to show charge
    #
    # Using mkAfter orders this setting after the shared waybar configuration so
    # that when configurations are merged "battery" ends up as the last module in
    # the list.
    modules-right = lib.mkAfter [ "battery" ];

    # Specify which network interface to display status of
    network.interface = "wlo1";
  };

  home.useOutOfStoreSymlinks = true;

  home.stateVersion = "23.05"; # Please read the comment before changing.
}
