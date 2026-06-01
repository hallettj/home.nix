{
  flake.nvim-config.colorscheme-zenbones =
    { pkgs, ... }:
    {
      specs.colorscheme-zenbones = with pkgs.vimPlugins; [
        lush-nvim
        zenbones-nvim
      ];
    };
}
