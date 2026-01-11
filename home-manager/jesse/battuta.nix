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
    ../features/helix
  ];

  my-settings = {
    show-battery-status = true;
    show-brightness = true;
  };

  programs.niri.settings = {
    outputs."eDP-1".scale = 2.0;
    input.tablet.map-to-output = "eDP-1";
    input.touch.map-to-output = "eDP-1";
  };

  programs.kitty.extraConfig = ''
    font_size 10.0
  '';

  programs.neovide.settings.font.size = 10;

  programs.swaylock.settings.image = pkgs.fetchurl {
    url = "https://w.wallhaven.cc/full/x6/wallhaven-x6l5vl.jpg"; # Source: https://wallhaven.cc/w/x6l5vl
    hash = "sha256-g2XGek4OqeLbOPAo146Iyfr/AJmQYmYuJ5dD0tVqqbg=";
  };

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
