{
  flake.nvim-config.dressing =
    { pkgs, ... }:
    {
      # Show input prompts in floating window; make selections with Telescope
      specs.dressing = {
        data = pkgs.vimPlugins.dressing-nvim;
        lazy = true;
        after = [ "lze" ];
        config = /* lua */ ''
          require("lze").load {
            "dressing.nvim",
            event = "DeferredUIEnter",
            after = function() require("dressing").setup {} end,
          }
        '';
      };
    };
}
