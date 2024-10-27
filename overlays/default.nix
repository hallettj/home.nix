# This file defines overlays
{ inputs, ... }:
let
  patch = pkg: patches: pkg.overrideAttrs (oldAttrs: {
    patches = (oldAttrs.patches or [ ]) ++ patches;
  });

  # Get these packages from unstable by default
  get-from-unstable = [
    "localsend" # v1.15 adds --hidden flag
    "neovide"
    "neovim"
    "neovim-unwrapped" # Home Manager uses unwrapped package
    "nickel"
    "nls"
    "nu_scripts"
    "nushell"
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
    # Need to patch 1password package to set native wayland mode until this
    # issue is resolved:
    # https://github.com/NixOS/nixpkgs/pull/232718#issuecomment-1582123406
    _1password-gui = patch prev._1password-gui [ ./1password-native-wayland.patch ];
    neovide = patch prev.neovide [ ./neovide-font-customization.patch ];

    rofi-wayland-unwrapped = prev.rofi-wayland-unwrapped.overrideAttrs (oldAttrs: {
      version = "main";
      src = final.fetchFromGitHub {
        owner = "lbonn";
        repo = "rofi";
        rev = "d88b475bad26a6ba60c85cd7830e441da5774cdb"; # latest as of 2024-07-16
        fetchSubmodules = true;
        hash = "sha256-JORQoLe3cc7f5muj7E9ldS89aRld4oZ/b5PAt7OH0jE=";
      };
    });
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

    xwayland-satellite = inputs.xwayland-satellite.packages.${final.system}.default;
  } // (builtins.listToAttrs (builtins.map (pkg: { name = pkg; value = final.unstable.${pkg}; }) get-from-unstable));

  nickel = final: prev: {
    nickel-lang-core = inputs.nickel.packages.${final.system}.nickel-lang-core;
    nickel-lang-cli = inputs.nickel.packages.${final.system}.nickel-lang-cli;
    nickel-lang-lsp = inputs.nickel.packages.${final.system}.nickel-lang-lsp;
  };

  niri = inputs.niri.overlays.niri;
}
