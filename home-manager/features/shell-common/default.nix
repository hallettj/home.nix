{ pkgs, ... }:

{
  # Manages and synchronizes shell history
  programs.atuin = {
    enable = true;
    flags = [ "--disable-up-arrow" ];
    package = pkgs.unstable.atuin;
    settings = {
      inline_height = 16;
      search_mode = "fuzzy";
      show_help = false;
      update_check = false;
      workspaces = true;
    };
  };

  programs.skim = {
    enable = true;
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

  home.packages = with pkgs; [
    bat
    fd
    fzf
    ripgrep
    xclip
  ];
}
