# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example'

{ inputs, pkgs }: {
  eza = inputs.eza.packages.${pkgs.system}.default; # replacement for ls
  # The typical pattern for local packages is:
  # my-package = pkgs.callPackage ./my-package.nix { src = inputs.my-package-source; };
}
