{
  flake.nvim-config.tiny-inline-diagnostic =
    { pkgs, ... }:
    {
      # Nicer virtual text display for diagnostics
      specs.tiny-inline-diagnostic = {
        data = pkgs.vimPlugins.tiny-inline-diagnostic-nvim;
        lazy = true;
        after = [ "lze" ];
        config = /* lua */ ''
          require("lze").load {
            "tiny-inline-diagnostic.nvim",
            event = "DeferredUIEnter",
            after = function()
              require("tiny-inline-diagnostic").setup {
                options = {
                  show_source = {
                    enabled = false,
                    if_many = false,
                  },
                  multilines = {
                    -- enabled = true, -- show diagnostics on multiple source lines unless cursor is on one of those lines
                  },
                },
              }
              vim.diagnostic.config { virtual_text = false } -- tiny handles virtual text
            end,
          }
        '';
      };
    };
}
