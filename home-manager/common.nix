{ config, flakePath, lib, inputs, outputs, pkgs, ... }:

{
  imports = [
    inputs.nix-index-database.hmModules.nix-index
    ./features/gnome
    ./features/kitty
    ./features/neovim
    ./features/nushell
    ./features/shell-common
    ./features/ssh
    ./features/zsh
  ] ++ (builtins.attrValues outputs.homeManagerModules);

  nixpkgs = {
    config = {
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = (_: true);
    };
  };

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
    authy
    discord
    enpass
    foliate
    gimp-with-plugins
    google-chrome
    masterpdfeditor
    obsidian
    pavucontrol
    signal-desktop
    slack
    transmission-gtk
    write_stylus
    xorg.xev # used by my `keycode` alias

    # Programming
    cachix
    cargo
    docker
    docker-compose
    rustc
    rust-analyzer
    clang
    nodejs_20

    # Nix utilities
    nurl
    sops

    # CLI
    jq
    fd
    killall
    lm_sensors
    gnupg
    ripgrep
    tree
    unzip

    # Backups
    borgbackup
    vorta
  ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    enableZshIntegration = true;
  };

  programs.firefox = {
    enable = true;
    profiles.default.settings = {
      # Full-screen does not actually make the window full screen. I use this
      # setting to abuse full-screen mode to hide the navigation and tab bars.
      "full-screen-api.ignore-widgets" = true;
    };
  };

  programs.git = {
    enable = true;
    userName = "Jesse Hallett";
    userEmail = "jesse@sitr.us";
    signing.key = "A5CC2BE3";
    aliases = {
      di = "diff --cached";
      lg = "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
      commend = "commit --amend --no-edit";
      up = "git fetch origin main:main";
    };
    extraConfig = {
      user.useConfigOnly = true;
      push.default = "simple";
      pull.ff = "only";
      core = {
        pager = "less -FR";
        autocrlf = "input";
        editor = "nvim";
      };
      rebase.autosquash = true;
      rerere = {
        enabled = true;
        autoupdate = true;
      };
      init = {
        defaultBranch = "main";
      };
    };
    ignores = [ "*.swo" "*.swp" ];
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Install comma to run programs without installing them. Requires
  # nix-index-database flake
  programs.nix-index-database.comma.enable = true;

  services.gpg-agent = {
    enable = true;
    pinentryFlavor = "gnome3";
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";
}
