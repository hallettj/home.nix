# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example'

{ inputs, pkgs }: {
  hasura3 = pkgs.callPackage ./hasura3-cli.nix {};
}
