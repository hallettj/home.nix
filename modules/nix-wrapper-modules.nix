# Import nix-wrapper-modules to get `flake.wrappers`

{ inputs, ... }:
{
  flake-file.inputs.wrappers = {
    url = "github:nix-community/nix-wrapper-modules";
    inputs.nixpkgs.follows = "nixpkgs";
  };
  imports = [ inputs.wrappers.flakeModules.wrappers ];
}
