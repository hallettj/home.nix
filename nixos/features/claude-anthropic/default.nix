{ config, ... }:

let
  # Secrets must be mapped using `sops.secrets` settings. See the end of this
  # file.
  secrets = config.sops.secrets;
in
{ 
  home-manager.users.jesse.home.sessionVariablesExtra = ''
    export ANTHROPIC_API_KEY
    ANTHROPIC_API_KEY="$(cat ${secrets.anthropic-api-key.path})"
  '';

  # Edit secrets file by running:
  #
  #     $ sops path/to/secrets.yaml
  #
  sops.secrets = {
    anthropic-api-key = {
      sopsFile = ./secrets.yaml;
      owner = config.users.users.jesse.name;
      group = config.users.users.jesse.group;
    };
  };
}
