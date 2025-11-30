{ inputs, ... }:

{
  imports = [ inputs.niri.nixosModules.niri ];
  programs.niri.enable = true;
  niri-flake.cache.enable = false; # opts out of including niri.cachix.org in binary substituters
}
