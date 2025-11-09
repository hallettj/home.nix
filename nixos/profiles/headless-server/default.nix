{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    kitty.terminfo
  ];
}

