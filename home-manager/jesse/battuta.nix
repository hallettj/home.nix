{ lib, ... }:

{
  imports = [
    ../common.nix
    ../features/games
  ];

  # Increase font sizes - it's cleaner than applying a display scaling factor.
  dconf.settings."org/gnome/desktop/interface" = {
    text-scaling-factor = 2.0;
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
}
