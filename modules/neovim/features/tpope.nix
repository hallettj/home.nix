# Install tpope's essential plugins
#
# I also have vim-fugitive configured in git.nix
{
  flake.nvim-config.tpope =
    { pkgs, ... }:
    {
      specs.tpope = with pkgs.vimPlugins; [
        vim-sensible # sensible configuration defaults
        vim-sleuth # heuristics to automatically set shiftwidth and expandtab for each buffer
        vim-unimpaired # shortcuts for cycling/toggling different things
        vim-characterize # show information about character under cursor
        vim-repeat # makes the `.` command work with third-party actions
        vim-rsi # add Emacs-like shortcuts to command mode
      ];
    };
}
