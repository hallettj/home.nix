# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example'

{ inputs, pkgs }: {
  eza = inputs.eza.packages.${pkgs.system}.default; # replacement for ls
  monaspace = pkgs.callPackage ./monaspace.nix { src = inputs.monaspace-source; };
}
