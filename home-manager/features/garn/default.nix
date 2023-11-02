{ inputs, pkgs, ... }:

{
  home.packages = [ inputs.garn.packages.${pkgs.system}.default ];
}
