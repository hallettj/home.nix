{ config, flakePath, pkgs, ... }:

let
  dir = "${flakePath config}/home-manager/features/nushell";
in
{
  programs.nushell = {
    enable = true;
    envFile.text = "source ${dir}/env.nu";
    configFile.text = "source ${dir}/config.nu";
  };

  # I'm not setting nushell as my login shell because it is not Posix, and it is
  # not super stable. Instead I'm configuring kitty to run nushell instead of my
  # login shell.
  programs.kitty.extraConfig = ''
    shell nu
  '';

  # Manages and synchronizes shell history
  programs.atuin = {
    enable = true;
    package = pkgs.unstable.atuin;
    settings = {
      inline_height = 16;
      show_help = false;
      update_check = false;
      workspaces = true;
    };
  };

  # Change directories with fuzzy search
  programs.zoxide.enable = true;
}
