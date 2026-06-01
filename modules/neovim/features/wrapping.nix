{
  flake.nvim-config.wrapping =
    { pkgs, ... }:
    {
      # Use heuristics to set hard or soft line wrapping mode per buffer
      specs.wrapping = {
        data = pkgs.vimPlugins.wrapping-nvim;
        config = /* lua */ ''
          require("wrapping").setup {
            notify_on_switch = false,
          }
        '';
      };
    };
}
