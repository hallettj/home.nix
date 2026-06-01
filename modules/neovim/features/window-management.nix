{
  flake.nvim-config.window-management =
    { pkgs, ... }:
    {
      specs.winshift = {
        data = pkgs.vimPlugins.winshift-nvim;
        lazy = true;
        after = [
          "lze"
          "which-key"
        ];
        config = /* lua */ ''
          local wk = require "which-key"

          wk.add {
            { "<leader>-", "<c-w>_", desc = "maximize vertically" },
            { "<leader>=", "<c-w>=", desc = "equal window sizes" },

            { "<c-left>", "<c-w>h", desc = "move to window on left" },
            { "<c-down>", "<c-w>j", desc = "move to window below" },
            { "<c-up>", "<c-w>k", desc = "move to window above" },
            { "<c-right>", "<c-w>l", desc = "move to window on right" },
          }

          require("lze").load {
            "winshift.nvim",

            cmd = { "WinShift" },

            keys = {
              { "<c-w><c-m>", "<cmd>WinShift<cr>", desc = "start win-move mode" },
              { "<c-w>m", "<cmd>WinShift<cr>", desc = "start win-move mode" },
              { "<c-w>X", "<cmd>WinShift swap<cr>", desc = "swap two windows" },

              -- <c-s-...> shortcuts work in Neovide, but might not work in terminal
              { "<c-s-left>", "<cmd>WinShift left<cr>", desc = "move window left" },
              { "<c-s-down>", "<cmd>WinShift down<cr>", desc = "move window down" },
              { "<c-s-up>", "<cmd>WinShift up<cr>", desc = "move window up" },
              { "<c-s-right>", "<cmd>WinShift right<cr>", desc = "move window right" },
            },

            after = function() require("winshift").setup {} end,
          }
        '';
      };
    };
}
