{
  config,
  inputs,
  lib,
  self,
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
  options.nixpkgs-unstable = {
    patches = lib.mkOption {
      type = lib.types.listOf lib.types.path;
      default = [ ];
      description = "Patches to apply to nixpkgs before initializing. For most modifications use overlays instead";
    };
  };

  config.flake.overlays = rec {
    # This one contains whatever you want to overlay
    # You can change versions, add patches, set compilation flags, anything really.
    # https://nixos.wiki/wiki/Overlays
    modifications = final: prev: {
      starship = patch prev.starship [ ./starship-ignore-atuin-when-counting-jobs.patch ];
    };

    # When applied, the unstable nixpkgs set (declared in the flake inputs) will
    # be accessible through 'pkgs.unstable'
    unstable-packages =
      final: _prev:
      let
        patches = config.nixpkgs-unstable.patches;
        nixpkgs-unstable =
          if patches == [ ] then
            inputs.nixpkgs-unstable
          else
            final.applyPatches {
              inherit patches;
              name = "nixpkgs";
              src = inputs.nixpkgs-unstable;
            };
      in
      {
        unstable = import nixpkgs-unstable {
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

  config.nixpkgs.overlays = with self.overlays; [
    modifications
    unstable-packages
  ];

  config.perSystem =
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
      # Build overlay modifications in checks so that we get caching from CI.
      checks = pkgsOnly modifiedPkgs;
    };
}
