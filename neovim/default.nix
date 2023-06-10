{ config, pkgs, lib, ... }:

let
  dir = "${config.xdg.configHome}/home-manager/neovim";
in
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    withPython3 = true;
  };

  home.file = {
    # Symlink config files in this directory. An absolute path is required when
    # using a flake config from home-manager because relative paths are
    # expanded after the flake source is copied to a store path.
    nvim-config = {
      source = config.lib.file.mkOutOfStoreSymlink "${dir}/nvim-config";
      target = ".config/nvim";
    };
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

  home.packages = with pkgs; [
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
}
