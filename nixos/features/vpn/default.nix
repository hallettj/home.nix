{ config, ... }:

let
  # Secrets must be mapped using `sops.secrets` settings. See the end of this
  # file.
  secrets = config.sops.secrets;
in
{
  services.openvpn.servers = {
    pia = {
      autoStart = false;
      # These of these options came from the OVPN file from
      # privateinternetaccess' OpenVPN configuration generator
      config = ''
        client
        dev tun
        proto udp
        remote us-california.privacy.network 1198
        resolv-retry infinite
        nobind
        persist-key
        persist-tun
        cipher aes-128-cbc
        auth sha1
        tls-client
        remote-cert-tls server

        auth-user-pass ${secrets.user-pass.path}
        compress
        verb 1
        reneg-sec 0
      
        # I don't think these values need to be private, but just in case.
        crl-verify ${secrets.crl-verify.path}
        ca ${secrets.ca.path}

        disable-occ
      '';
    };
  };

  # Edit secrets file by running:
  #
  #     $ sops path/to/secrets.yaml
  #
  sops.secrets = {
    user-pass.sopsFile = ./secrets.yaml;
    crl-verify.sopsFile = ./secrets.yaml;
    ca.sopsFile = ./secrets.yaml;
  };
}
