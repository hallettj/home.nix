{ config, lib, ... }:

let
  folder = ./caches;
  toImport = name: value: folder + ("/" + name);
  filterCaches = key: value: value == "regular" && lib.hasSuffix ".nix" key;
in
{
  imports = lib.mapAttrsToList toImport (lib.filterAttrs filterCaches (builtins.readDir folder));

  # netrc contains passwords to access private binary caches - see the line
  # below that sets content for that file from sops secrets
  nix.settings.netrc-file = [ "/etc/nix/netrc" ];

  environment.etc = {
    "nix/netrc" = {
      source = config.sops.secrets.netrc.path;
    };
  };

  # Edit secrets file by running:
  #
  #     $ sops path/to/secrets.yaml
  #
  sops.secrets = {
    netrc.sopsFile = ./secrets.yaml;
  };
}
