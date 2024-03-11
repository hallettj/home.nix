# This file defines overlays
{ inputs, ... }:
let
  patch = pkg: patches: pkg.overrideAttrs (oldAttrs: {
    patches = (oldAttrs.patches or [ ]) ++ patches;
  });
in
rec {
  # This one brings our custom packages from the 'pkgs' directory
  additions = final: _prev: import ../pkgs { inherit inputs; pkgs = final; };

  # This one contains whatever you want to overlay
  # You can change versions, add patches, set compilation flags, anything really.
  # https://nixos.wiki/wiki/Overlays
  modifications = final: prev: {
    neovide = patch prev.neovide [ ./neovide-font-customization.patch ];
  };

  # When applied, the unstable nixpkgs set (declared in the flake inputs) will
  # be accessible through 'pkgs.unstable'
  unstable-packages = final: _prev: {
    unstable = import inputs.nixpkgs-unstable {
      # Apply the same system, config, and overlays to 'pkgs.unstable' that are
      # applied to 'pkgs'
      system = final.system;
      config = final.config;
      overlays = [additions modifications];
    };
  };

  neovim-nightly = inputs.neovim-nightly-overlay.overlay;
}
