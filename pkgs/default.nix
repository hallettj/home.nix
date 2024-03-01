# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example'

{ inputs, pkgs }: {
  eza = inputs.eza.packages.${pkgs.system}.default; # replacement for ls
  git-butler = pkgs.callPackage ./git-butler.nix {};
  hasura3 = pkgs.callPackage ./hasura3-cli.nix {};
}
