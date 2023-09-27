{ config, outputs, ... }:

{
  imports = [
    outputs.nixosModules.nixbuild
  ];

  # Configure remote builds on nixbuild.net
  services.nixbuild = {
    enable = true;
    identityFile = "/etc/ssh/ssh_host_ed25519_key";
    systems = [
      "i686-linux"
      "aarch64-linux"
      "armv7l-linux"
    ];
  };
}
