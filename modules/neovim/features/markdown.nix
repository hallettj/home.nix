{
  flake.nvim-config.markdown =
    { pkgs, ... }:
    {
      specs.render-markdown = {
        data = with pkgs.vimPlugins; [
          nvim-web-devicons
          render-markdown-nvim
        ];
        lazy = true;
        after = [ "lze" ];
        config = /* lua */ ''
          require('lze').load {
            'render-markdown.nvim',
            ft = { 'markdown' },
            after = function() require('render-markdown').setup {} end,
          }
        '';
      };
    };
}
