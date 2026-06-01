{
  flake.nvim-config.mundo =
    { config, pkgs, ... }:
    {
      specs.mundo = {
        data = pkgs.vimPlugins.vim-mundo;
        lazy = true;
        after = [ "lze" ];
        config = /* lua */ ''
          require("lze").load {
            "vim-mundo",
            cmd = { "MundoToggle" },
            keys = {
              { "<leader>u", "<cmd>MundoToggle<cr>", desc = "toggle Mundo" },
            },
          }
        '';
      };
    };
}
