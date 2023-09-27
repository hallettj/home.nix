{ config, flakePath, lib, pkgs, ... }:

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
    package = pkgs.unstable.nushell;
    envFile.text = "source ${dir}/env.nu";
    configFile.text = let nu_scripts = pkgs.unstable.nu_scripts; in "
      ${use_completions [
        "cargo"
        "git"
        "make"
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

  # The direnv nushell integration in Hame Manager 23.05 is not updated for the
  # latest nushell. So we're doing it ourselves.
  programs.direnv.enableNushellIntegration = false;
  programs.nushell.extraConfig =
    # Using mkAfter to make it more likely to appear after other
    # manipulations of the prompt.
    lib.mkAfter ''
      $env.config = ($env | default {} config).config
      $env.config = ($env.config | default {} hooks)
      $env.config = ($env.config | update hooks ($env.config.hooks | default [] pre_prompt))
      $env.config = ($env.config | update hooks.pre_prompt ($env.config.hooks.pre_prompt | append {
        code: "
          let direnv = (${pkgs.direnv}/bin/direnv export json | from json)
          let direnv = if not ($direnv | is-empty) { $direnv } else { {} }
          $direnv | load-env
          "
      }))
    '';

  # Get newer version of starship with an init script that is compatible with
  # the latest nushell
  programs.starship.package = pkgs.unstable.starship;

  # Change directories with fuzzy search
  programs.zoxide = {
    enable = true;
    # Get newer version of zoxide with an init script that is compatible with
    # the latest nushell
    package = pkgs.unstable.zoxide;
  };
}
