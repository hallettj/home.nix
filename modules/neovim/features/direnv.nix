{
  flake.nvim-config.direnv =
    { pkgs, ... }:
    {
      # Automatically load environment variables set in a `.envrc` or `.env` file
      # when changing to a directory with such a file.
      specs.direnv.data = pkgs.vimPlugins.direnv-vim;
    };
}
