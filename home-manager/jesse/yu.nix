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
    ../features/warp-terminal
  ];

  screen-type.aspect-ratio = "ultrawide";
}
