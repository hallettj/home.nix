{ outputs, pkgs, ... }:

{
  imports = [
    outputs.homeManagerModules.screen-type
    outputs.homeManagerModules.useOutOfStoreSymlinks
    ../common.nix
    ../profiles/desktop
    ../features/godot
    ../features/obs
    ../features/vscode
  ];

  my-settings = {
    show-brightness = true;
    defaultWallpaper =
      (pkgs.fetchurl {
        url = "https://w.wallhaven.cc/full/md/wallhaven-mdyvvm.jpg"; # Source: https://wallhaven.cc/w/mdyvvm
        hash = "sha256-1JtqfH1htLqprk3W8pkdscT/5w5lYflsO+f20m7dmbg=";
      }).outPath;
  };
  screen-type.aspect-ratio = "ultrawide";

  # Increase font sizes - it's cleaner than applying a display scaling factor.
  dconf.settings."org/gnome/desktop/interface" = {
    text-scaling-factor = 1.25;
  };

  programs.kitty.extraConfig = ''
    font_size 12.0
  '';

  home.packages = with pkgs; [
    gparted
    love # 2D game engine
    parted
    shotcut
  ];

  home.useOutOfStoreSymlinks = true;

  home.stateVersion = "23.05"; # Please read the comment before changing.
}
