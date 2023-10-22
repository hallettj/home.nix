{ ... }:

{
  imports = [
    ../common.nix
    ../features/games
    ../features/gnome
    ../features/godot
    ../features/kitty
    ../features/neovim
    ../features/nushell
    ../features/wezterm
    ../features/zsh
  ];

  screen-type.aspect-ratio = "ultrawide";
}
