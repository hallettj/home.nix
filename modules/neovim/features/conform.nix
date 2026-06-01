{
  flake.nvim-config.conform =
    { pkgs, ... }:
    {
      specs.conform = {
        data = pkgs.vimPlugins.conform-nvim;
        lazy = true;
        after = [ "lze" ];
        config = /* lua */ ''
          require('lze').load {
            'conform.nvim',

            keys = {
              { '<leader><space>', function() require('conform').format() end, desc = 'format document' },
            },

            after = function()
              require('conform').setup {
                default_format_opts = {
                  lsp_format = 'fallback',
                },
                formatters_by_ft = {
                  javascript = { 'prettierd', 'prettier', stop_after_first = true },
                  typescript = { 'prettierd', 'prettier', stop_after_first = true },
                  lua = { 'stylua' },
                  nix = { 'injected', 'nixfmt' },
                  python = { 'black' },
                  sql = { 'sqlfluff' },
                  yaml = { 'prettier' },
                },
              }
            end,
          }
        '';
      };

      runtimePkgs = with pkgs; [
        black # python code formatter
        isort # python import sorter
        codespell
        nixfmt
        prettier
        prettierd
        sqlfluff # sql
        stylua
      ];
    };
}
