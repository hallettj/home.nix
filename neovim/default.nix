{ config, pkgs, lib, ... }:

let
  # Out-of-store symlinks require absolute paths when using a flake config. This
  # is because relative paths are expanded after the flake source is copied to
  # a store path which would get us read-only store paths.
  dir = "${config.xdg.configHome}/home-manager/neovim";
in
{
  xdg.configFile.nvim = {
    source = config.lib.file.mkOutOfStoreSymlink "${dir}/nvim-config";
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    withPython3 = true;
    extraPackages = with pkgs; [
      fd
      gh # for github integration
      ripgrep

      # needed to compile fzf-native for telescope-fzf-native.nvim
      gcc
      gnumake

      # language servers
      rnix-lsp
      lua-language-server
    ];
  };

  home.sessionVariables = {
    # Disable the top window bar in Neovide
    NEOVIDE_FRAME = "none";

    # Enable Neovim's multigrid functionality for EXTREME FANCINESS.
    # Specifically transparency for floating windows, window animations, and
    # smooth scrolling.
    NEOVIDE_MULTIGRID = "true";

    # I just don't want extra UI anywhere
    NVIM_GTK_NO_HEADERBAR = "1";
  };
}
