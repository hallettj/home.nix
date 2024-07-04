{ inputs, ... }:

{
  imports = [ inputs.niri.nixosModules.niri ];
  programs.niri.enable = true;
  # programs.niri.package = pkgs.niri-unstable; # remove this line to switch to latest stable niri release
}
