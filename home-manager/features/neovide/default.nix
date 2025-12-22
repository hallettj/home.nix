{ lib, pkgs, ... }:

{
  programs.neovide = {
    enable = true;
    settings = {
      frame = "none"; # disable the top window bar
      font = {
        normal = [ "Cartograph CF" ];
        size = lib.mkDefault 12;
      };
    };
  };

  home.packages = with pkgs; [
    wl-clipboard # used by obsidian.nvim to interact with clipboard
  ];

  home.sessionVariables = {
    # I just don't want extra UI anywhere
    NVIM_GTK_NO_HEADERBAR = "1";
  };
}
