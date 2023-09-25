{ config, flakePath, pkgs, ... }:

let
  dir = "${flakePath config}/home-manager/features/nushell";

  nu_scripts = pkgs.unstable.nu_scripts;
  use_completions = cmds:
    let
      imports =
        builtins.map (cmd: "use ${nu_scripts}/share/nu_scripts/custom-completions/${cmd}/${cmd}-completions.nu *") cmds;
    in
    builtins.concatStringsSep "\n" imports;
in
{
  programs.nushell = {
    enable = true;
    envFile.text = "source ${dir}/env.nu";
    configFile.text = let nu_scripts = pkgs.unstable.nu_scripts; in "
      ${use_completions [
        "cargo"
        "git"
        "make"
        "man" 
        "nix"
        "npm"
      ]}
      use ${nu_scripts}/share/nu_scripts/custom-completions/yarn/yarn-completion.nu *

      use ${nu_scripts}/share/nu_scripts/modules/filesystem/expand.nu
      use ${nu_scripts}/share/nu_scripts/modules/nix/nix.nu *

      source ${dir}/config.nu
    ";
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
    flags = [ "--disable-up-arrow" ];
    package = pkgs.unstable.atuin;
    settings = {
      inline_height = 16;
      search_mode = "skim";
      show_help = false;
      update_check = false;
      workspaces = true;
    };
  };

  # Change directories with fuzzy search
  programs.zoxide.enable = true;
}
