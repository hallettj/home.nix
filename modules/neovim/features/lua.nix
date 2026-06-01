{
  flake.nvim-config.lua =
    { pkgs, ... }:
    {
      # Properly configure LuaLS for editing Neovim configuration
      specs.lazydev = {
        data = pkgs.vimPlugins.lazydev-nvim;
        lazy = true;
        after = [ "lze" "blink" ];
        config = /* lua */ ''
          require("lze").load {
            "lazydev.nvim",
            ft = "lua", -- only load on lua files

            after = function()
              require("lazydev").setup {
                library = {
                  -- See the configuration section for more details
                  -- Load luvit types when the `vim.uv` word is found
                  { path = "''${3rd}/luv/library", words = { "vim%.uv" } },
                },
              }

              local blink = require "blink.cmp"
              blink.add_source_provider("lazydev", {
                name = "LazyDev",
                module = "lazydev.integrations.blink",
                -- make lazydev completions top priority (see `:h blink.cmp`)
                score_offset = 100,
              })
              blink.add_filetype_source("lua", "lazydev")
            end,
          }
        '';
      };
    };
}
