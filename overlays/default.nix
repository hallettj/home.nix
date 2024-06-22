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
    # Need to patch 1password package to set native wayland mode until this
    # issue is resolved:
    # https://github.com/NixOS/nixpkgs/pull/232718#issuecomment-1582123406
    _1password-gui = patch prev._1password-gui [ ./1password-native-wayland.patch ];
    gitbutler = (import inputs.nixpkgs-gitbutler {
      localSystem = final.buildPlatform.system;
      crossSystem = final.hostPlatform.system;
      config = final.config;
    }).gitbutler;
    neovide = patch prev.neovide [ ./neovide-font-customization.patch ];
  };

  # When applied, the unstable nixpkgs set (declared in the flake inputs) will
  # be accessible through 'pkgs.unstable'
  unstable-packages = final: _prev: {
    unstable = import inputs.nixpkgs-unstable {
      # Apply the same system, config, and overlays to 'pkgs.unstable' that are
      # applied to 'pkgs'
      localSystem = final.buildPlatform.system;
      crossSystem = final.hostPlatform.system;
      config = final.config;
      overlays = [ additions modifications ];
    };

    # Get these packages from unstable by default
    neovide = final.unstable.neovide;
    neovim = final.unstable.neovim;
    neovim-unwrapped = final.unstable.neovim-unwrapped; # Home Manager uses unwrapped package
    rust-analyzer = final.unstable.rust-analyzer;
  };

  niri = inputs.niri.overlays.niri;
}
