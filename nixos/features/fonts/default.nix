{ pkgs, ... }:

{
  fonts.packages = with pkgs; [
    cantarell-fonts
    nerd-fonts.symbols-only
  ];
}
