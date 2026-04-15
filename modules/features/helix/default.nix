flakeParts:

let
  flakePath = flakeParts.config.flakePath;
in
{
  flake.modules.homeManager.helix =
    { config, pkgs, ... }:

    let
      # Out-of-store symlinks require absolute paths when using a flake config. This
      # is because relative paths are expanded after the flake source is copied to
      # a store path which would get us read-only store paths.
      useOutOfStoreSymlinks =
        if builtins.hasAttr "useOutOfStoreSymlinks" config.home then
          config.home.useOutOfStoreSymlinks
        else
          false;
      dir = "${flakePath}/modules/features/helix";
    in
    {
      xdg.configFile."helix/config.toml".source =
        if useOutOfStoreSymlinks then
          config.lib.file.mkOutOfStoreSymlink "${dir}/config.toml"
        else
          ./config.toml;

      programs.helix = {
        enable = true;
        package = pkgs.helix;

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
            config.formatting.command = [ "${pkgs.nixpkgs-fmt}/bin/nixpkgs-fmt" ];
          };
        };
      };
    };
}
