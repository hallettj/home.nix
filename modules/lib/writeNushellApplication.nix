{ self, ... }:

{
  # Export overlay
  flake.overlays.writeNushellApplication = (
    final: prev: {
      writeNushellApplication = final.callPackage ./_writeNushellApplication.nix { };
    }
  );

  # and also apply it internally
  nixpkgs.overlays = [ self.overlays.writeNushellApplication ];
}
