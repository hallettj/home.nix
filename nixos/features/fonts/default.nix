{ pkgs, ... }:

{
  fonts.packages = with pkgs; [
    # Need a nerdfont to get icons
    (nerdfonts.override { fonts = [ "NerdFontsSymbolsOnly" ]; })
  ];
}
