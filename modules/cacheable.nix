# Aggregates everything that should be pushed to my binary cache into one
# derivation so that CI does not have to enumerate hosts by hand. Building this
# package realizes every system closure for the current system; pushing its
# closure to Attic is then enough to install any host without compiling.
{ lib, self, ... }:

{
  perSystem =
    {
      config,
      pkgs,
      system,
      ...
    }:
    let
      forSystem = lib.filterAttrs (_: drv: drv.system == system);

      nixosToplevels =
        lib.mapAttrs'
          (name: nixos: {
            name = "nixos-${name}";
            value = nixos.config.system.build.toplevel;
          })
          (
            lib.filterAttrs (_: nixos: nixos.pkgs.stdenv.hostPlatform.system == system) self.nixosConfigurations
          );

      # Standalone Home Manager configurations, if I ever add any.
      homeActivationPackages = lib.mapAttrs' (name: home: {
        name = "home-${name}";
        value = home.activationPackage;
      }) (forSystem (self.homeConfigurations or { }));

      # Flake packages, minus this aggregate itself.
      ownPackages = lib.mapAttrs' (name: package: {
        name = "package-${name}";
        value = package;
      }) (builtins.removeAttrs config.packages [ "cacheable" ]);
    in
    {
      packages.cacheable = pkgs.linkFarm "cacheable" (
        nixosToplevels // homeActivationPackages // ownPackages
      );
    };
}
