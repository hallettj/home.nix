{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "jesse";
  home.homeDirectory = "/home/jesse";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.05"; # Please read the comment before changing.
  home.enableNixpkgsReleaseCheck = true;

  # Workaround to allow non-free packages from nixpkgs
  nixpkgs.config.allowUnfreePredicate = pkg: true;

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # GUI apps
    authy
    discord
    enpass
    google-chrome
    masterpdfeditor
    obsidian
    pavucontrol
    signal-desktop
    slack
    write_stylus

    # Programming
    cachix
    cargo
    docker
    docker-compose
    rustc
    rust-analyzer
    clang
    nodejs_20

    # CLI
    jq
    fd
    ripgrep
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

  home.file = {
    ".XCompose".source = dotfiles/XCompose;
  };

  # You can also manage environment variables but you will have to manually
  # source
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/jesse/etc/profile.d/hm-session-vars.sh
  #
  # if you don't want to manage your shell through Home Manager.
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
