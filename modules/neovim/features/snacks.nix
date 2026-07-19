{
  flake.nvim-config.snacks = { pkgs, ... }: {
    specs.snacks = {
      data = pkgs.vimPlugins.snacks-nvim;
      config = /* lua */ ''
        require("snacks").setup {
          bigfile = { enabled = false },
          dashboard = { enabled = false },
          explorer = { enabled = false },
          indent = { enabled = false },
          input = { enabled = false },
          picker = { enabled = true }, -- used by jj.nvim
          notifier = { enabled = false },
          quickfile = { enabled = false },
          scope = { enabled = false },
          scroll = { enabled = false },
          statuscolumn = { enabled = false },
          words = { enabled = false },
        }
      '';
    };
  };
}
