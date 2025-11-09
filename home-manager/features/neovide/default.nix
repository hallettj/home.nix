{ pkgs, ... }:

{
  home.packages = with pkgs; [
    unstable.neovide # Get v0.15.1 from unstable for fix for text not rendering in center line in leftmost window

    wl-clipboard # used by obsidian.nvim to interact with clipboard
  ];

  home.sessionVariables = {
    # Disable the top window bar in Neovide
    NEOVIDE_FRAME = "none";

    # I just don't want extra UI anywhere
    NVIM_GTK_NO_HEADERBAR = "1";
  };
}
