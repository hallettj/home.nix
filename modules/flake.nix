# Sets up generating repo-root flake.nix file by running `nix run
# .#write-flake`. In addition to the settings here, that command gathers
# settings like `flake-file.inputs` from all flake-parts modules in this repo.

{ inputs, ... }:

{
  # Use flake-file to bootstrap flake-file. This import does a number of things:
  #
  # - adds flake inputs: flake-file, flake-parts, import-tree
  # - imports flake-parts modules: flake-parts.flakeModules.modules
  # - adds write-file app to flake
  # - adds flake check to verify that generated flake is up-to-date
  # - sets default output for flake-file to "dendritic".
  # - sets default nixpkgs input URL
  imports = [
    inputs.flake-file.flakeModules.dendritic
  ];

  flake-file = {
    description = "NixOS and Home Manager configuration for Jesse Hallett";
    outputs = "dendritic"; # uses flake-parts & import-tree to import everything in /modules
  };
}
