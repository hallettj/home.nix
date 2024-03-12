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
    package = pkgs.unstable.nushell;
    envFile.text = "source ${dir}/env.nu";
    configFile.text = ''
      ${use_completions [
        "cargo"
        "git"
        "just"
        "make"
        "nix"
        "npm"
      ]}
      use ${nu_scripts}/share/nu_scripts/custom-completions/yarn/yarn-v4-completions.nu *

      use ${nu_scripts}/share/nu_scripts/modules/filesystem/expand.nu
      use ${nu_scripts}/share/nu_scripts/modules/nix/nix.nu *

      source ${dir}/config.nu
    '';
  };

  # Change directories with fuzzy search
  programs.zoxide.enable = true;

  # Temporarily set up zoxide nushell integration manually because the Home
  # Manager 23.11 zoxide module is not updated for the latest nushell version.
  # This is copied from 
  # https://github.com/nix-community/home-manager/blob/3df2a80f3f85f91ea06e5e91071fa74ba92e5084/modules/programs/zoxide.nix
  programs.zoxide.enableNushellIntegration = false;
  programs.nushell = {
    extraEnv = ''
      let zoxide_cache = "${config.xdg.cacheHome}/zoxide"
      if not ($zoxide_cache | path exists) {
        mkdir $zoxide_cache
      }
      ${config.programs.zoxide.package}/bin/zoxide init nushell ${builtins.concatStringsSep " " config.programs.zoxide.options} |
        str replace "def-env" "def --env" --all |  # https://github.com/ajeetdsouza/zoxide/pull/632
        str replace --all "-- $rest" "-- ...$rest" |
        save --force ${config.xdg.cacheHome}/zoxide/init.nu
    '';
    extraConfig = ''
      source ${config.xdg.cacheHome}/zoxide/init.nu
    '';
  };

  # I'm not setting nushell as my login shell because it is not Posix, and it is
  # not super stable. Instead I'm configuring kitty to run nushell instead of my
  # login shell.
  programs.kitty.extraConfig = ''
    shell nu
  '';

  # and do the same for wezterm
  xdg.configFile."wezterm/autoload/default_prog_nu.lua".text = ''
    local module = {}
    function module.configure(config)
      config.default_prog = { '${config.programs.nushell.package}/bin/nu' }
    end
    return module
  '';
}
