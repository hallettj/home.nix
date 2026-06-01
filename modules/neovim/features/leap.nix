{ inputs, ... }:
{
  flake-file.inputs.telepath-nvim = {
    url = "github:rasulomaroff/telepath.nvim";
    flake = false;
  };

  flake.nvim-config.leap =
    { config, pkgs, ... }:
    {
      # `s`/`S` command jumps forward/backward to occurrence of a pair of characters
      # `gw` jumps to pair of characters in another window
      specs.leap = {
        data = with pkgs.vimPlugins; [
          vim-repeat
          leap-nvim
        ];
        after = [ "lze" ];
        config = /* lua */ ''
          require('lze').load {
            'leap.nvim',
            keys = {
              -- default mappings, except that I changed 'gs' to 'gw', and 's' and 'S' are inclusive motions
              { 's', mode = { 'n', 'x', 'o' }, '<Plug>(leap-forward)', desc = 'Leap forward' },
              { 'S', mode = { 'n', 'x', 'o' }, '<Plug>(leap-backward)', desc = 'Leap backward' },
              { 'x', mode = { 'x', 'o' }, '<Plug>(leap-forward-till)', desc = 'eXclusive leap motion forward' },
              { 'X', mode = { 'x', 'o' }, '<Plug>(leap-backward-till)', desc = 'eXclusive leap motion backward' },
              { 'gw', mode = { 'n', 'x', 'o' }, '<Plug>(leap-from-window)', desc = 'Leap to another window' },
            },
            dep_of = { 'telepath.nvim' },
            after = function()
              local leap = require 'leap'
              leap.opts.labels = 'uhetonaspgcrkmjwqvlzidyfxb/UHETONASPGCRKMJWQVLZIDYFXB?' -- dvorak!
            end,
          }
        '';
      };

      specs.telepath = {
        data = config.nvim-lib.mkPlugin "telepath.nvim" inputs.telepath-nvim;
        lazy = true;
        after = [
          "lze"
          "leap"
        ];
        config = /* lua */ ''
          require('lze').load {
            'telepath.nvim',
            keys = {
              {
                'r',
                mode = 'o',
                function() require('telepath').remote { restore = true } end,
                desc = 'operate on remote textobject, use leap search to set start point',
              },
              {
                'R',
                mode = 'o',
                function() require('telepath').remote { restore = true, recursive = true } end,
                desc = 'operate on remote textobject recursively, use leap search to set start point',
              },
              {
                'm',
                mode = 'o',
                function() require('telepath').remote() end,
                desc = 'operate on remote textobject and move cursor there, use leap search to set start point',
              },
              {
                'M',
                mode = 'o',
                function() require('telepath').remote { recursive = true } end,
                desc = 'operate on remote textobject recursively and move cursor there, use leap search to set start point',
              },
            },
          }
        '';
      };
    };
}
