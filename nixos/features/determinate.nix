{ inputs, pkgs, ... }:

{
  # Use Determinate Systems' version of the nix command
  nix.package = inputs.determinate-nix.packages.${pkgs.stdenv.system}.default;

  # Experimental feature that provides faster, and less resource-intensive nix
  # evaluation
  nix.settings.lazy-trees = true;

  # nh (Yet Another Nix Helper) checks nix' experimental features list by
  # default to verify that nix-command and flakes are enabled. Determinate Nix
  # omits those from the list because Determinate has those permanently enabled.
  #
  # See https://github.com/nix-community/nh/issues/305
  environment.sessionVariables.NH_NO_CHECKS = "1";
}
