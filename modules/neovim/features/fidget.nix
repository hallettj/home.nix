{
  flake.nvim-config.fidget =
    { pkgs, ... }:
    {
      # show progress messages from language servers
      specs.fidget = {
        data = pkgs.vimPlugins.fidget-nvim;
        after = [ "lze" ];
        lazy = true;
        config = /* lua */ ''
          require('lze').load {
            'fidget.nvim',
            event = 'LspAttach',
            after = function()
              require('fidget').setup {
                progress = {
                  display = {
                    progress_icon = { 'dots_ellipsis' },
                  },
                },
              }
            end,
          }
        '';
      };
    };
}
