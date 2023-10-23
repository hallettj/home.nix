{ ... }:

{
  imports = [
    ../common.nix
    ../features/games
    ../features/godot
    ../features/wezterm
  ];

  screen-type.aspect-ratio = "ultrawide";
}
