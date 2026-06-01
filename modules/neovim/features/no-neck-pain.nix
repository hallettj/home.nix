{
  flake.nvim-config.no-neck-pain =
    { pkgs, ... }:
    {
      specs.no-neck-pain = {
        data = pkgs.vimPlugins.no-neck-pain-nvim;
        lazy = true;
        after = [ "lze" ];
        config = /* lua */ ''
          require("lze").load {
            "no-neck-pain.nvim",

            keys = {
              { "<leader>np", mode = { "n" }, function() require("no-neck-pain").toggle() end, desc = "toggle No Neck Pain" },
              {
                "<leader>ns",
                mode = { "n" },
                function() require("no-neck-pain").toggle_scratch_pad() end,
                desc = "toggle scratch pad",
              },
            },

            after = function()
              require("no-neck-pain").setup {
                width = 160,
              }
            end,
          }
        '';
      };
    };
}
