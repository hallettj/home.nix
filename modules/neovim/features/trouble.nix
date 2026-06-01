{
  flake.nvim-config.trouble =
    { pkgs, ... }:
    {
      specs.trouble = {
        data = with pkgs.vimPlugins; [
          nvim-web-devicons
          trouble-nvim
        ];
        after = [ "lze" ];
        config = /* lua */ ''
          require("lze").load {
            "trouble.nvim",

            keys = {
              { "<leader>xw", "<cmd>Trouble diagnostics toggle<cr>", desc = "workspace diagnostics" },
              { "<leader>xb", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "buffer diagnostics" },
              { "<leader>xc", "<cmd>Trouble close<cr>", desc = "close trouble diagnostics" },
              { "<leader>cs", "<cmd>Trouble symbols toggle<cr>", desc = "symbols overview sidebar" },
              { "<leader>cl", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", desc = "LSP info sidebar" },
            },

            after = function() require("trouble").setup {} end,
          }
        '';
      };
    };
}
