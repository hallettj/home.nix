{ outputs, lib, config, ... }:

let
  inherit (config.networking) hostName;
  hosts = outputs.nixosConfigurations;
  pubKey = host: ../${host}/ssh_host_ed25519_key.pub;
in
{
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
      # Automatically remove stale sockets
      StreamLocalBindUnlink = "yes";
      # Allow forwarding ports to everywhere
      GatewayPorts = "clientspecified";
    };
    hostKeys = [{
      path = "/etc/ssh/ssh_host_ed25519_key";
      type = "ed25519";
    }];
  };

  programs.ssh = {
    # Prepopulate knownHosts with public keys for each host configured in this
    # repo
    knownHosts = builtins.mapAttrs
      (name: _: {
        publicKeyFile = pubKey name;
        extraHostNames = lib.optional (name == hostName) "localhost";
      })
      hosts;
  };

  # Passwordless sudo when SSH'ing with keys
  security.pam.enableSSHAgentAuth = true;
}
