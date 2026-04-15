{ self, ... }:

{
  flake.nixosModules.hallettj-base = self.modules.nixos.common;
  flake.homeModules.hallettj-base = self.modules.homeManager.common;
}
