# Configures access to nixbuild.net for remote builds.

{ config, lib, ... }:

with lib;

let
  cfg = config.services.nixbuild;

  supportedSystems = [
    "x86_64-linux"
    "i686-linux"
    "aarch64-linux"
    "armv7l-linux"
  ];

  buildMachine = system: {
    hostName = "eu.nixbuild.net";
    system = system;
    maxJobs = 100;
    supportedFeatures = [ "benchmark" "big-parallel" ];
  };
in
{
  options.services.nixbuild = {
    enable = mkEnableOption "nix-build";

    identityFile = mkOption {
      type = types.path;
      description = ''
        Path to a public SSH key that has been registered with nixbuild.net
      '';
    };

    systems = mkOption {
      type = types.listOf (types.enum supportedSystems);
      default = supportedSystems;
      description = ''
        List of systems to enable remote builds on nixbuild.net for.

        Supported systems are: ${builtins.toString supportedSystems}
      '';
    };
  };

  config = mkIf cfg.enable {
    programs.ssh.extraConfig = ''
      Host eu.nixbuild.net
        PubkeyAcceptedKeyTypes ssh-ed25519
        IdentityFile ${cfg.identityFile}
    '';

    programs.ssh.knownHosts = {
      nixbuild = {
        hostNames = [ "eu.nixbuild.net" ];
        publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPIQCZc54poJ8vqawd8TraNryQeJnvH1eLpIDgbiqymM";
      };
    };

    nix = {
      settings.builders-use-substitutes = true;
      distributedBuilds = true;
      buildMachines = builtins.map buildMachine cfg.systems;
    };
  };
}
