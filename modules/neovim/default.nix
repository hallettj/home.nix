flakeParts@{ lib, withSystem, ... }:

{
  # My neovim configuration is split into multiple nix modules which each assign
  # an attribute to flake.nvim-config
  options.flake.nvim-config = lib.mkOption {
    type = lib.types.attrsOf lib.types.deferredModule;
    description = "nix-wrapper-modules wrappers to import in the main neovim configuration below";
    default = { };
  };

  # Create a self-contained neovim package with my configuration, plugins, and
  # runtime dependencies. This is exported from the flake as a package named
  # "neovim". (The package name is taken from `flake.wrappers.<whatever name>`)
  config.flake.wrappers.neovim =
    { pkgs, wlib, ... }:
    {
      imports = [
        wlib.wrapperModules.neovim
      ]
      ++ builtins.attrValues flakeParts.config.flake.nvim-config;

      settings.config_directory = ./nvim-config;

      # info injects data into neovim via require(vim.g.nix_info_plugin_name)(null, "nested", "attr", "path")
      info = { };

      # Lazy loading helper
      specs.lze = {
        data = pkgs.vimPlugins.lze;
        name = "lze";
      };
    };

  # After defining a custom neovim package, install it
  config.flake.modules.homeManager.neovim =
    {
      config,
      pkgs,
      ...
    }:
    {
      home.packages = withSystem pkgs.stdenv.hostPlatform.system (
        { self', ... }: [ self'.packages.neovim ]
      );
    };
}
