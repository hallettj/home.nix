{ inputs, ... }:

{
  flake-file.inputs = {
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  imports = [
    # Import module that defines flake.homeModules output
    inputs.home-manager.flakeModules.home-manager
  ];
}
