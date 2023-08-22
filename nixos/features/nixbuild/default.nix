{ outputs, ... }:

{
  imports = [
    outputs.nixosModules.nixbuild
  ];

  # Configure remote builds on nixbuild.net
  services.nixbuild = {
    enable = false;
    identityFile = "/root/nixbuild-key";
    systems = [
      # "x86_64-linux"
      "i686-linux"
      "aarch64-linux"
      "armv7l-linux"
    ];
  };
}
