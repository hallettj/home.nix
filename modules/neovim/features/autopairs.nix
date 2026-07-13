{
  flake.nvim-config.autopairs =
    { pkgs, ... }:
    {
      specs.autopairs = {
        data = pkgs.vimPlugins.nvim-autopairs;
        config = /* lua */ ''
          require('nvim-autopairs').setup {
            check_ts = true;
          }
        '';
      };
    };
}
