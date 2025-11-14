{ config, flakePath, lib, pkgs, ... }:

let
  # Out-of-store symlinks require absolute paths when using a flake config. This
  # is because relative paths are expanded after the flake source is copied to
  # a store path which would get us read-only store paths.
  useOutOfStoreSymlinks =
    if builtins.hasAttr "useOutOfStoreSymlinks" config.home
    then config.home.useOutOfStoreSymlinks
    else false;
  dir = "${flakePath config}/home-manager/features/zsh";
  symlink = path:
    let p = lib.strings.removePrefix "." path; in
    if useOutOfStoreSymlinks then config.lib.file.mkOutOfStoreSymlink dir + p else ./. + p;
in
{
  programs.zsh = {
    enable = true;
    zplug = {
      enable = true;
      zplugHome = "${config.xdg.cacheHome}/zplug";
    };
    initContent = ''
      # Use Solarized theme colors for directory listings
      [[ -s "$HOME/.dircolors" ]] && eval `dircolors "$HOME/.dircolors"`

      # Source configurations from ~/.config/zsh/conf.d/*
      configs="$HOME/.config/zsh/conf.d"
      if [ -d "$configs" ]; then
        for conf in "$configs/"*.zsh; do
          source "$conf"
        done
        unset conf
      fi
      unset configs
    '';
  };

  home.file = {
    zsh-config = {
      source = symlink "./home/.config/zsh";
      target = ".config/zsh";
    };
    dircolors = { source = symlink "home/.dircolors"; target = ".dircolors"; };
    inputrc = { source = symlink "home/.inputrc"; target = ".inputrc"; };
  };

  # Replacement for ls
  programs.eza = {
    enable = true;
    enableZshIntegration = true;
  };

  home.packages = with pkgs; [
    fd
    fzf
    ripgrep
    xclip
  ];
}
