{ config, flakePath, pkgs, ...}:

let
  # Out-of-store symlinks require absolute paths when using a flake config. This
  # is because relative paths are expanded after the flake source is copied to
  # a store path which would get us read-only store paths.
  dir = "${flakePath config}/home-manager/features/helix";
in
{
  xdg.configFile."helix/config.toml".source = config.lib.file.mkOutOfStoreSymlink "${dir}/config.toml";

  programs.helix = {
    enable = true;
    package = pkgs.unstable.helix;

    extraPackages = with pkgs; [
      deno
      lua-language-server
      nil # Nix LSP
      nls # Nickel LSP
      nodePackages.bash-language-server
      nodePackages.typescript-language-server
      shellcheck # called by bash-language-server
    ];

    languages = {
      language-server.nil = {
        config.formatting.command = ["${pkgs.nixpkgs-fmt}/bin/nixpkgs-fmt"];
      };
    };
  };
}
