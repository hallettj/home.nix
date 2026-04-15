{ inputs, ... }:

{
  # Prebuilt package index - provides comma package
  flake-file.inputs.nix-index-database = {
    url = "github:Mic92/nix-index-database";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  flake.modules.homeManager.nix-index-database = {
    imports = [
      inputs.nix-index-database.homeModules.nix-index
    ];
    programs.nix-index-database.comma.enable = true;
  };
}
