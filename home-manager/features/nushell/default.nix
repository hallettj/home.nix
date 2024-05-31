{ config, flakePath, pkgs, ... }:

let
  dir = "${flakePath config}/home-manager/features/nushell";

  nu_scripts = pkgs.nu_scripts;
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
    package = pkgs.nushell;
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
