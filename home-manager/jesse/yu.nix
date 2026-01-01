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

  programs.niri.settings.outputs."DP-1" = {
    scale = 1.33;
    variable-refresh-rate = true;
  };

  programs.kitty.extraConfig = ''
    font_size 10.0
  '';

  programs.neovide.settings.font.size = 10;

  home.packages = with pkgs; [
    gparted
    love # 2D game engine
    parted
    shotcut
  ];

  home.useOutOfStoreSymlinks = true;

  home.stateVersion = "23.05"; # Please read the comment before changing.
}
