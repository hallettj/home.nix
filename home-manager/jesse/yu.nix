{ ... }:

{
  imports = [
    ../common.nix
    ../features/games
    ../features/git-butler
    ../features/godot
    ../features/helix
    ../features/niri
    ../features/obs
    ../features/vscode
  ];

  screen-type.aspect-ratio = "ultrawide";
}
