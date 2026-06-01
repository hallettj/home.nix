{
  flake.nvim-config.comment =
    { pkgs, ... }:
    {

      # Manipulate code comments
      specs.comment = {
        data = pkgs.vimPlugins.comment-nvim;
        config = /* lua */ ''
          require('Comment').setup()
        '';
      };
    };
}
