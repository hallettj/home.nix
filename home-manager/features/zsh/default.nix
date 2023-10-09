{ config, flakePath, inputs, pkgs, ... }:

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
    initExtra = ''
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

  programs.skim = {
    enable = true;
    enableZshIntegration = true;
    fileWidgetCommand = "fd --type f";
    fileWidgetOptions = [ "--preview='bat --color=always {}'" ];
  };

  programs.starship.enable = true;
  programs.starship.settings = {
    character = {
      success_symbol = "[❯](bold green)";
      error_symbol = "[❯](bold red)";
      vimcmd_symbol = "[❮](bold yellow)";
    };
    package.disabled = true;
    nix_shell = {
      format = "via [$symbol$state]($style) ";
      symbol = "❄️";
      impure_msg = "";
      pure_msg = "pure";
    };
    status.disabled = false;
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
    bat
    inputs.eza.packages.${pkgs.system}.default # replacement for ls
    fd
    fzf
    ripgrep
    xclip
  ];
}
