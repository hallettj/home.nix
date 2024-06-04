# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example'

{ inputs, pkgs }: {
  cli-ddn = pkgs.callPackage ./cli-ddn.nix { };
}
