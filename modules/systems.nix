{ inputs, ... }:

# Externally extensible Nix systems pattern https://github.com/nix-systems/nix-systems
{
  flake-file.inputs.systems.url = "github:nix-systems/default";
  systems = import inputs.systems;
}
