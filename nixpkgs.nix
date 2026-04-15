# A nixpkgs instance that is grabbed from the pinned nixpkgs commit in the lock file
# This is useful to avoid using channels when using legacy nix commands
let
  lockfile = (builtins.fromJSON (builtins.readFile ./flake.lock));
  root-id = lockfile.root;
  nixpkgs-id = lockfile.nodes.${root-id}.inputs.nixpkgs;
  lock = lockfile.nodes.${nixpkgs-id}.locked;
in
import (fetchTarball {
  url = "https://github.com/nixos/nixpkgs/archive/${lock.rev}.tar.gz";
  sha256 = lock.narHash;
})
