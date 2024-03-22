{ ... }:

{
  imports = [
    ../common.nix
    ../features/games
    ../features/godot
    ../features/helix
    ../features/niri
    ../features/obs
    ../features/vscode
  ];

  screen-type.aspect-ratio = "ultrawide";
}
