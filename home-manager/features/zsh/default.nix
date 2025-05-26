{ config, flakePath, pkgs, ... }:

let
  link = path: config.lib.file.mkOutOfStoreSymlink "${flakePath config}/home-manager/features/zsh/${path}";
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
      source = link "home/.config/zsh";
      target = ".config/zsh";
    };
    dircolors = { source = link "home/.dircolors"; target = ".dircolors"; };
    inputrc = { source = link "home/.inputrc"; target = ".inputrc"; };
  };

  home.packages = with pkgs; [
    fd
    fzf
    ripgrep
    xclip
  ];
}
