# Manage repo-specific jj settings. This includes formatters to apply when running `jj fix`.
#
# Applies settings to the workspace config in case I use a workspace to adjust
# jj settings.
#
# Takes over management of the workspace jj config. Anything written to that
# file will be replaced!
{
  perSystem =
    { lib, pkgs, ... }:
    {
      devShells.jj =
        let
          jj-config.fix.tools = {
            lua = {
              command = [
                (lib.getExe pkgs.stylua)
                "--stdin-filepath=$path"
                "-"
              ];
              patterns = [ "glob:'**/*.lua'" ];
            };

            nixfmt = {
              command = [
                (lib.getExe pkgs.nixfmt)
                "--filename=$path"
              ];
              patterns = [ "glob:'**/*.nix'" ];
            };

            prettier = {
              command = [
                (lib.getExe pkgs.prettier)
                "--stdin-filepath=$path"
              ];
              patterns = [
                ''
                  glob:'**/*.[jt]s' | glob:'**/*.[jt]sx' | glob:'**/*.json' | glob:'**/*.md'
                ''
              ];
            };

            toml = {
              command = [
                (lib.getExe pkgs.taplo)
                "fmt"
                "--stdin-filepath=$path"
                "-"
              ];
              patterns = [ "glob:'**/*.toml'" ];
            };
          };

          toml-format = pkgs.formats.toml { };
          config = toml-format.generate "config.toml" jj-config;
        in
        pkgs.mkShell {
          # Use lib.getExe to call jj without installing it in the devShell
          # which would override the system jj version
          shellHook = ''
            config_path=$(${lib.getExe pkgs.jujutsu} config path --workspace)
            ln -sf "${config}" "$config_path"
          '';
        };
    };
}
