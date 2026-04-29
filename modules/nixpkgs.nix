{
  config,
  inputs,
  lib,
  ...
}:

with lib.types;
{
  options.nixpkgs = {
    config = lib.mkOption {
      type = submodule {
        freeformType = anything;
      };
      default = { };
      description = "Configuration for the pkgs set that is injected with perSystem";
    };

    overlays = lib.mkOption {
      type = listOf raw;
      default = [ ];
      description = "Overlays that will be applied to the pkgs set injected with perSystem";
    };

    patches = lib.mkOption {
      type = listOf path;
      default = [ ];
      description = "Patches to apply to nixpkgs before initializing. For most modifications use overlays instead";
    };
  };

  config.flake-file.inputs.nixpkgs = lib.mkDefault {
    url = "github:nixos/nixpkgs/nixos-unstable";
  };

  config.perSystem =
    {
      pkgs,
      system,
      ...
    }:
    let
      patches = config.nixpkgs.patches;
      nixpkgs =
        if patches == [ ] then
          inputs.nixpkgs
        else
          pkgs.applyPatches {
            inherit patches;
            name = "nixpkgs";
            src = inputs.nixpkgs;
          };
    in
    {
      # Sets pkgs in flake-parts, for example in the pkgs attribute to the
      # perSystem argument.
      _module.args.pkgs = import nixpkgs {
        inherit system;
        inherit (config.nixpkgs) config overlays;
      };
    };
}
