# Borg is for Backups
{
  flake.modules.homeManager.borg =
    { pkgs, ... }:

    {
      home.packages = with pkgs; [
        borgbackup
        vorta
      ];
    };
}
