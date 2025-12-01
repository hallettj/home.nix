{ pkgs, ... }:

{
  imports = [
    ../../features/borg
    ../../features/firefox
    ../../features/gnome
    ../../features/kitty
    ../../features/neovide
    ../../features/niri
    ../../features/xcompose
  ];

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # GUI apps
    discord
    element-desktop
    foliate
    gimp-with-plugins
    google-chrome
    inkscape-with-extensions
    mission-center
    obsidian
    pavucontrol
    slack
    transmission_4-gtk
    xorg.xev # used by my `keycode` alias

    # Programming
    cargo
    docker
    docker-compose
    ngrok
    rustc
    rust-analyzer
    clang
    nodejs_20

    # Fonts
    lexend
  ];

  services.gpg-agent = {
    enable = true;
    pinentry.package = pkgs.pinentry-gnome3;
  };
}

