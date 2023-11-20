{ ... }:

{
  imports = [
    ../common.nix
    ../features/games
    ../features/garn
    ../features/godot
    ../features/niri
    ../features/obs
    ../features/wezterm
  ];

  screen-type.aspect-ratio = "ultrawide";
}
