{
  flake.nvim-config.neotest =
    { pkgs, ... }:
    {
      specs.neotest = {
        data = with pkgs.vimPlugins; [
          nvim-nio
          plenary-nvim
          neotest
        ];
        lazy = true;
        after = [
          "lze"
          "rustaceanvim"
          "treesitter"
        ];
        config = /* lua */ ''
          require("lze").load {
            "neotest",
            keys = {
              -- stylua: ignore start
              { '<leader>tt', mode = 'n', function() require('neotest').run.run() end,                     desc = 'run the nearest test' },
              { '<leader>dt', mode = 'n', function() require('neotest').run.run({ strategy = "dap" }) end, desc = 'debug the nearest test' },
              { '<leader>t%', mode = 'n', function() require('neotest').run.run(vim.fn.expand('%')) end,   desc = 'run all tests in current file' },
              { '<leader>tS', mode = 'n', function() require('neotest').run.stop() end,                    desc = 'stop the nearest test' },
              { '<leader>ta', mode = 'n', function() require('neotest').run.stop() end,                    desc = 'attach to the nearest test' },
              { '<leader>to', mode = 'n', function() require('neotest').output.open() end,                 desc = 'show test output' },
              { '<leader>tp', mode = 'n', function() require('neotest').output_panel.toggle() end,         desc = 'toggle test panel' },
              { '<leader>ts', mode = 'n', function() require('neotest').summary.toggle() end,              desc = 'toggle test summary sidebar' },
              { '<leader>tw', mode = 'n', function() require('neotest').watch.toggle() end,                desc = 'start/stop watching test' },
              -- stylua: ignore end
            },
            after = function()
              require("neotest").setup {
                adapters = {
                  require "rustaceanvim.neotest",
                },
                output_panel = {
                  open = "topleft vsplit | vertical resize 80", -- open panel in vertical split
                },
              }
            end,
          }
        '';
      };
    };
}
