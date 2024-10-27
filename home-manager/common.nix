{ config, flakePath, lib, inputs, outputs, pkgs, ... }:

{
  imports = [
    inputs.nix-index-database.hmModules.nix-index
    ./features/eza
    ./features/firefox
    ./features/git
    ./features/gnome
    ./features/kitty
    ./features/localsend
    ./features/neovim
    ./features/niri
    ./features/nushell
    ./features/shell-common
    ./features/ssh
    ./features/xcompose
    ./features/zsh
  ] ++ (builtins.attrValues outputs.homeManagerModules);

  home = {
    username = lib.mkDefault "jesse";
    homeDirectory = lib.mkDefault "/home/jesse";
    sessionVariables = {
      FLAKE = flakePath config;
    };
    stateVersion = "23.05"; # Please read the comment before changing.
    enableNixpkgsReleaseCheck = true;
  };

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # GUI apps
    discord
    element-desktop
    enpass
    foliate
    gimp-with-plugins
    google-chrome
    inkscape-with-extensions
    masterpdfeditor
    obsidian
    pavucontrol
    signal-desktop
    slack
    transmission-gtk
    write_stylus
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

    # Nix utilities
    nurl
    sops

    # CLI
    cli-ddn
    file
    jq
    fd
    killall
    lm_sensors
    gnupg
    ripgrep
    tree
    unzip

    # Fonts
    lexend

    # Backups
    borgbackup
    vorta
  ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    enableZshIntegration = true;
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Install comma to run programs without installing them. Requires
  # nix-index-database flake
  programs.nix-index-database.comma.enable = true;

  services.gpg-agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-gnome3;
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";
}
