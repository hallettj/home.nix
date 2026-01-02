{ inputs, pkgs, ... }:

{
  imports = [
    # inputs.stylix.homeModules.stylix
    ../../features/borg
    ../../features/firefox
    ../../features/gnome
    ../../features/kitty
    ../../features/neovide
    ../../features/niri
    ../../features/noctalia
    ../../features/swayidle
    ../../features/xcompose
  ];

  stylix = {
    #   # enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-macchiato.yaml";
    fonts = {
      # serif = {
      #   package = pkgs.dejavu_fonts;
      #   name = "DejaVu Serif";
      # };
      sansSerif = {
        package = pkgs.cantarell-fonts;
        name = "Cantarell";
      };
      monospace = {
        # package = Todo;
        name = "Cartograph CF";
      };
    };
    targets = {
      firefox.profileNames = [ "default" ];
      neovim.enable = false;
    };
  };

  # stylix.targets.qt.enable = false; # getting an error

  # qt.qt5ctSettings = {};

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
