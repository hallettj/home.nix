{
  inputs,
  lib,
  self,
  withSystem,
  ...
}:

let
  patch =
    pkg: patches:
    pkg.overrideAttrs (oldAttrs: {
      patches = (oldAttrs.patches or [ ]) ++ patches;
    });

  # Get these packages from unstable by default
  get-from-unstable = [
    "rust-analyzer"
  ];
in
{
  flake.overlays = rec {
    # Flake packages get added to package set, which propagates to NixOS and
    # Home Manager
    additions =
      final: prev: withSystem prev.stdenv.hostPlatform.system ({ config, ... }: config.packages);

    # This one contains whatever you want to overlay
    # You can change versions, add patches, set compilation flags, anything really.
    # https://nixos.wiki/wiki/Overlays
    modifications = final: prev: {
      starship = patch prev.starship [ ./starship-ignore-atuin-when-counting-jobs.patch ];
      vimPlugins = prev.vimPlugins // {
        # Fix from https://github.com/yetone/avante.nvim/pull/2985
        avante-nvim = patch prev.vimPlugins.avante-nvim [ ./avante-support-sonnet-4-6.patch ];
      };
    };

    # When applied, the unstable nixpkgs set (declared in the flake inputs) will
    # be accessible through 'pkgs.unstable'
    unstable-packages =
      final: _prev:
      {
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
          system = final.stdenv.hostPlatform.system;
          overlays = [
            additions
            modifications
          ]; # unstable gets the same overlays as the base pkg set
        };
      }
      // (builtins.listToAttrs (
        builtins.map (pkg: {
          name = pkg;
          value = final.unstable.${pkg};
        }) get-from-unstable
      ));
  };

  perSystem =
    { pkgs, system, ... }:
    let
      # Get set of packages added or modified by overlay
      overlayPkgs = overlay: overlay pkgs pkgs;
      modifiedPkgs = builtins.intersectAttrs (overlayPkgs self.overlays.modifications) pkgs;

      # Filter to remove nested package sets, like vimPlugins, because
      # distinguishing modified packages in nested sets is more complication than
      # is worth my time.
      pkgsOnly = lib.filterAttrs (key: value: lib.isDerivation value);
    in
    {
      # Build overlay modifications in checks so that we get caching on Garnix.
      # Additions are automatically built when running checks because they are
      # also flake package outputs.
      checks = pkgsOnly modifiedPkgs;
    };
}
