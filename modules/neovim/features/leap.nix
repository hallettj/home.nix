{
  flake.nvim-config.leap =
    { config, pkgs, ... }:
    {
      specs.leap = {
        data = [
          pkgs.vimPlugins.vim-repeat
          pkgs.unstable.vimPlugins.leap-nvim
        ];
        config = /* lua */ ''
          -- See `:h leap-mappings`, `:h leap.visit-mappings` for more.

          local map = vim.keymap.set

          -- Jump
          map({ "n", "x", "o" }, "s", "<Plug>(leap)", { desc = "Leap" })
          map("n", "S", "<Plug>(leap-anywhere)", { desc = "Leap in any window" })

          -- eXclusive motion
          map({ "x", "o" }, "x", "<Plug>(leap-next-to)", { desc = "Leap next to" })

          -- Visit (jump - operate - jump back)
          map({ "n", "x", "o" }, "gs", "<Plug>(leap-visit)", { desc = "Leap visit" })
          map({ "n", "x", "o" }, "gS", "<Plug>(leap-visit-linewise)", { desc = "Leap visit linewise" })
          map({ "o" }, "r", "<Plug>(leap-visit)", { desc = "Leap visit (operator pending)" }) -- matches the binding I had from telepath.nvim
          -- map({ "o" }, "R", "<Plug>(leap-visit-linewise)", { desc = "Leap visit linewise (operator pending)" })
          map({ "x", "o" }, "ar", "<Plug>(leap-visit-text-object)", { desc = "Leap visit text object" })
          map({ "x", "o" }, "ir", "<Plug>(leap-visit-inner-text-object)", { desc = "Leap visit inner text object" })
          -- map({ "o" }, "rr", "<Plug>(leap-visit-line)", { desc = "Leap visit line" }) -- TODO: what's the difference betwen visit-line and visit-linewise?

          -- -- Automatic paste on return.
          -- vim.api.nvim_create_autocmd("User", {
          --   pattern = "VisitDone",
          --   group = vim.api.nvim_create_augroup("Visit", {}),
          --   callback = function(event)
          --     if
          --       -- See |leap-visit-visual|.
          --       (event.data.mode:match "^[vV\22]" or (vim.v.operator == "y"))
          --       -- Skip if some special register was in use.
          --       and event.data.register == '"'
          --     then
          --       vim.cmd "normal! p"
          --     end
          --   end,
          -- })

          -- Treeselect
          map(
            { "x", "o" },
            "an",
            function()
              require("leap.treesitter").select {
                opts = require("leap.user").with_traversal_keys("n", "N"),
              }
            end
          )

          local leap = require "leap"
          leap.opts.labels = "uhetonaspgcrkmjwqvlzidyfxb/UHETONASPGCRKMJWQVLZIDYFXB?" -- dvorak!
        '';
      };
    };
}
