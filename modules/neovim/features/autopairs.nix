{
  flake.nvim-config.autopairs =
    { pkgs, ... }:
    {
      specs.autopairs = {
        data = pkgs.vimPlugins.nvim-autopairs;
        config = /* lua */ ''
          require("nvim-autopairs").setup {
            check_ts = true, -- Treesitter support
            enable_check_bracket_line = false, -- disables this heuristic: if next character is a close pair and it doesn't have an open pair in same line, then it will not add a close pair
          }
        '';
      };
    };
}
