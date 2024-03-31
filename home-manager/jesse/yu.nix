{ ... }:

{
  imports = [
    ../common.nix
    ../features/games
    ../features/godot
    ../features/obs
    ../features/vscode
  ];

  screen-type.aspect-ratio = "ultrawide";

  # Increase font sizes - it's cleaner than applying a display scaling factor.
  dconf.settings."org/gnome/desktop/interface" = {
    text-scaling-factor =  1.25;
  };

  programs.kitty.extraConfig = ''
    font_size 12.0
  '';

  programs.waybar.settings.mainBar = {
    # Specify which network interface to display status of
    network.interface = "wlp4s0";
  };
}
