{ config, flakePath, ... }:

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
}
