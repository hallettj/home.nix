# This file defines overlays
{ inputs, ... }:
let
  patch = pkg: patches: pkg.overrideAttrs (oldAttrs: {
    patches = (oldAttrs.patches or [ ]) ++ patches;
  });

  # Get these packages from unstable by default
  get-from-unstable = [
    "_1password-gui"
    "_1password-cli"
    "neovim"
    "neovim-unwrapped" # Home Manager uses unwrapped package
    "wrapNeovimUnstable" # Home Manager calls this in its neovim module
    "nls"
    "rust-analyzer"
  ];
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
      config = final.config;
      # I'd rather use these settings instead of just setting `system`:
      #
      #     localSystem = final.buildPlatform.system;
      #     crossSystem = final.hostPlatform.system;
      #
      # But when I do that nix rebuilds the entire stdenv when I try to install
      # wine packages, and that fails due to this bug:
      # https://github.com/NixOS/nixpkgs/issues/291271
      system = final.system;
      overlays = [ additions modifications ];
    };
  } // (builtins.listToAttrs (builtins.map (pkg: { name = pkg; value = final.unstable.${pkg}; }) get-from-unstable));

  niri = inputs.niri.overlays.niri;
}
