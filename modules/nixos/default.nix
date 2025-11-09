# Add your reusable NixOS modules to this directory, on their own file (https://nixos.wiki/wiki/Module).
# These should be stuff you would like to share with others, not your personal configurations.

{
  # Reusable modules
  nixbuild = import ./nixbuild.nix;

  # Exported configurations
  hallettj-base = import ../../nixos/common.nix;
}
