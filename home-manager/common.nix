{ config, flakePath, lib, inputs, pkgs, ... }:

{
  imports = [
    inputs.nix-index-database.homeModules.nix-index
    ./features/git
    ./features/neovim
    ./features/nushell
    ./features/shell-common
    ./features/ssh
    ./features/tig
    ./features/zsh
  ];

  home = {
    username = lib.mkDefault "jesse";
    homeDirectory = lib.mkDefault "/home/jesse";
    sessionVariables = {
      NH_FLAKE = flakePath config;
    };
    enableNixpkgsReleaseCheck = true;
  };

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # Nix utilities
    nurl
    sops

    # CLI
    file
    jq
    fd
    killall
    lm_sensors
    gnupg
    ripgrep
    tree
    unzip
  ];

  # In addition to managing Bash this creates ~/.profile which loads
  # home.sessionVariables on non-NixOS systems
  programs.bash.enable = true;

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

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";
}
