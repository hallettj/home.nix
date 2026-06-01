{
  flake.nvim-config.textobjects =
    { pkgs, ... }:
    {
      specs.kana = {
        data = with pkgs.vimPlugins; [
          vim-textobj-user # dependency for kana's other textobj plugins
          vim-textobj-entire # `ae`: entire buffer, `ie`: excludes empty lines
          vim-textobj-line # `al`: entire line, `il` excludes whitespace
          vim-niceblock # makes `I` and `A` work in line-wise visual mode
        ];
      };
    };
}
