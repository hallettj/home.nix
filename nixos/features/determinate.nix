{ pkgs, inputs, ... }:

{
  # Use Determinate Systems' version of the nix command
  nix.package = inputs.determinate-nix.packages.${pkgs.stdenv.system}.default;

  # Experimental feature that provides faster, and less resource-intensive nix
  # evaluation
  nix.settings.lazy-trees = true;
}
