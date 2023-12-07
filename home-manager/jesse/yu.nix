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
}
