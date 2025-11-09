# Borg is for Backups
{ pkgs, ... }:

{
  home.packages = with pkgs; [
    borgbackup
    vorta
  ];
}
