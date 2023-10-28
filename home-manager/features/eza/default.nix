{ pkgs, ... }:

{
  programs.nushell.extraConfig = ''
    # Alias ls to eza, but keep a reference to nu's internal table-outputting ls
    # under a different alias.
    alias nuls = ls
    alias ls = ${pkgs.eza}/bin/eza
  '';

  programs.zsh.initExtra = ''
    # Alias ls to eza
    alias ls="${pkgs.eza}/bin/eza"
  '';
}
