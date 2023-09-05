# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example' or (legacy) 'nix-build -A example'

{ inputs, pkgs }: {
  # example = pkgs.callPackage ./example { };
  niri = pkgs.callPackage ./niri.nix { inherit inputs; };
  paperwm = pkgs.callPackage ./paperwm.nix { };
}
