# Sops manages version-controlled, encrypted secrets

{ inputs, ... }:

{
  flake-file.inputs = {
    sops-nix = {
      url = "github:mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  flake.modules.nixos.sops =
    { config, ... }:
    let
      isEd25519 = k: k.type == "ed25519";
      getKeyPath = k: k.path;
      keys = builtins.filter isEd25519 config.services.openssh.hostKeys;
    in
    {
      imports = [
        inputs.sops-nix.nixosModules.sops
      ];

      sops = {
        age.sshKeyPaths = map getKeyPath keys;
      };
    };
}
