{ config, flakePath, pkgs, ... }:

let
  dir = "${flakePath config}/home-manager/features/nushell";
  nu_scripts = pkgs.nu_scripts;
in
{
  programs.nushell = {
    enable = true;
    package = pkgs.nushell;
    envFile.text = "source ${dir}/env.nu";
    configFile.text = ''
      use ${nu_scripts}/share/nu_scripts/modules/filesystem/expand.nu
      use ${nu_scripts}/share/nu_scripts/modules/nix/nix.nu *

      # Eza integration will alias ls, but I want to keep a reference to nu's
      # internal table-outputting ls under a different alias.
      alias nuls = ls

      source ${dir}/config.nu
    '';
  };

  programs.carapace = {
    enable = true;
    enableNushellIntegration = true;
  };

  # Replacement for ls
  programs.eza = {
    enable = true;
    enableNushellIntegration = true;
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
