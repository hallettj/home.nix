# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example'

{ inputs, pkgs }: {
  eza = inputs.eza.packages.${pkgs.system}.default; # replacement for ls
  hasura3 = pkgs.callPackage ./hasura3-cli.nix {};
  # The typical pattern for local packages is:
  # my-package = pkgs.callPackage ./my-package.nix { src = inputs.my-package-source; };
}
