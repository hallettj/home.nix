{ config, lib, options, ... }:

let
  folder = ./caches;
  toImport = name: value: folder + ("/" + name);
  filterCaches = key: value: value == "regular" && lib.hasSuffix ".nix" key;
  usingDeterminate = builtins.hasAttr "determinate" options && config.determinate.enable;
in
{
  imports = lib.mapAttrsToList toImport (lib.filterAttrs filterCaches (builtins.readDir folder));

  # Without Determinate Nix

  # netrc contains passwords to access private binary caches - see the line
  # below that sets content for that file from sops secrets
  nix.settings.netrc-file = lib.mkIf (!usingDeterminate) [ "/etc/nix/netrc" ];
  environment.etc."nix/netrc" = lib.mkIf (!usingDeterminate) {
    source = config.sops.secrets.netrc.path;
  };

  # With Determinate Nix

  # Determinate manages the system netrc file so if Determinate is enabled then
  # we need to register netrc settings through its system.
  environment.etc."determinate/config.json" = lib.mkIf usingDeterminate {
    text = builtins.toJSON {
      authentication.additionalNetrcSources = [ config.sops.secrets.netrc.path ];
    };
  };

  # Edit secrets file by running:
  #
  #     $ sops path/to/secrets.yaml
  #
  sops.secrets.netrc.sopsFile = ./secrets.yaml;
}
