{ pkgs, ... }:

{
  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
      obs-backgroundremoval
      obs-pipewire-audio-capture
      obs-source-clone
      obs-vkcapture
    ];
  };

  home.packages = with pkgs; [ vlc ];

  # Install fixed youtube video loader
  home.file = {
    ".local/share/vlc/lua/playlist/youtube.lua".source = ./youtube.lua;
  };
}
