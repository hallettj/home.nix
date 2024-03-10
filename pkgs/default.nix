# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example'

{ inputs, pkgs }: {
  git-butler = pkgs.callPackage ./git-butler.nix {};
  hasura3 = pkgs.callPackage ./hasura3-cli.nix {};
}
