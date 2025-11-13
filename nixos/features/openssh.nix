{ outputs, lib, config, ... }:

let
  inherit (config.networking) hostName;
  hosts = outputs.nixosConfigurations;
  pubKey = host: ../${host}/ssh_host_ed25519_key.pub;
  otherKnownHosts = {
    "github.com" = {
      publicKeys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl"
        "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBEmKSENjQEezOmxkZMy7opKgwFB9nkt5YRrYMjNuG5N87uRgg6CLrbo5wAdT/y6v0mKV0U2w0WZ2YB/++Tpockg="
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCj7ndNxQowgcQnjshcLrqPEiiphnt+VTTvDP6mHBL9j1aNUkY4Ue1gvwnGLVlOhGeYrnZaMgRK6+PKCUXaDbC7qtbW8gIkhL7aGCsOr/C56SJMy/BCZfxd1nWzAOxSDPgVsmerOBYfNqltV9/hWCqBywINIR+5dIg6JTJ72pcEpEjcYgXkE2YEFXV1JHnsKgbLWNlhScqb2UmyRkQyytRLtL+38TGxkxCflmO+5Z8CSSNY7GidjMIZ7Q4zMjA2n1nGrlTDkzwDCsw+wqFPGQA179cnfGWOWRVruj16z6XyvxvjJwbz0wQZ75XK5tKSb7FNyeIEs4TT4jk+S4dhPeAUC5y+bDYirYgM4GC7uEnztnZyaVWQ7B381AK4Qdrwt51ZqExKbQpTUNn+EjqoTwvqNj4kqx5QUCI0ThS/YkOxJCXmPUWZbhjpCg56i+2aB6CmK2JGhn57K5mj0MNdBXA4/WnwH6XoPWJzK5Nyu2zB3nAZp+S5hpQs+p1vN1/wsjk="
      ];
    };
    "sr.ht" = {
      publicKeys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK2aDX5hsoJLPmz3Rs2Tx2ymYJhDjZjR2Be2DImhu6Kk"
      ];
    };
    "borgbase" = {
      hostNames = [ "efjn7220.repo.borgbase.com" "kd9sk70h.repo.borgbase.com" "t5gkkxea.repo.borgbase.com" ];
      publicKeys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGU0mISTyHBw9tBs6SuhSq8tvNM8m9eifQxM+88TowPO"
        "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBHYDOAh9uJnuVsYEZHDORpMbLHPWUoNSFTA84/Q4U/d99rDp2LE4Kr+kHHpuR6IXOSpoiTAg500CX+Q6IWJybHE="
      ];
    };
    "homeassistant" = {
      publicKeys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG02b6lYr1EX3td0DXztqcxTRZYnz49gP+eDehx64R85"
        "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBED8eF1G8begDAXNLfKAy+vG1oG0Gfdhy4YvtKXJbwdoxUV4NyhFZlRQA7Ql3l1QKjZqsGlzNc27v3YKTfgr6Nk="
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDjtHmy/GxQBvBc/O22iYtO5H2pMnuXgpPT4k8t4KpOo78e6hXMku4DER/XxlyP7NopYFSycb/v5DG7OGE1mZAcQiGF8Fp4C+K+ghSYt+crjETMsMuBLAfo5JOQfwpBx6PE7Fpv8gui0D6F8DozWSKguf2T0z9jCHH3Lk9OVkhsO6PYFdRKaSxOuVfTUTaHDhJWBohRhbPRaPrrrWPQ2COg3KJ0o6CjKne7GpWe39I0tQsFxVSFXoCWA4lOwR6ssPfK2MncCFcUGYkXjsf4aOpPWFOmrwnMo/FK5s09BL4i4ydbFZiWf2d4Vw6RrwaaSM7AfggHrmeLeIK9JPXkP5M50PM7Sma0F1//x7HxjZM6gjMX7Re5GLHCCTPgYYKND57W2c6/NuKjszSzGbhRvxHeApXRIQ5qtwU1JBpyriTkDDvt0u2WxOZ9oZir84EoZcpyKpe6260fdzvdVHnI4Nn9RIcv3CPKIDu6Acu2FX/2+qk2fveUlPwvX1sFU7LuEk0="
      ];
    };
    "hypatia.local" = {
      publicKeys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPRAFMQkdPnEaYhOPP1TDa1/yxbb8xfRFzCaRq7E+BMX root@hypatia"
      ];
    };
  };
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
    knownHosts = (builtins.mapAttrs
      (name: _: {
        publicKeyFile = pubKey name;
        extraHostNames = [ (name + ".local") ] ++ lib.optional (name == hostName) "localhost";
      })
      (lib.filterAttrs (name: _: builtins.pathExists (pubKey name)) hosts)) //
    # And also with the values from otherKnownHosts, converted to the format
    # expected by programs.ssh.knownHosts.*
    builtins.listToAttrs (
      builtins.concatMap
        (hostId:
          let host = builtins.getAttr hostId otherKnownHosts;
          in builtins.map
            (publicKey:
              {
                name = "${hostId}/${publicKey}";
                value = {
                  inherit publicKey;
                  hostNames = if (builtins.hasAttr "hostNames" host) then host.hostNames else [ hostId ];
                };
              }
            )
            host.publicKeys
        )
        (builtins.attrNames otherKnownHosts)
    );
  };

  # Passwordless sudo when SSH'ing with keys
  security.pam.sshAgentAuth.enable = true;
}
