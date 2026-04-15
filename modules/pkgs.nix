{ inputs, self, ... }:

{
  flake-file.inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    # Also see the 'unstable-packages' overlay at 'overlays/default.nix'.
  };

  perSystem =
    { system, pkgs, ... }:
    {
      # Sets pkgs in flake-parts, for example in the pkgs attribute to the
      # perSystem argument.
      _module.args.pkgs = import inputs.nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = builtins.attrValues self.overlays; # overlays from overlays.nix
      };
    };
}
