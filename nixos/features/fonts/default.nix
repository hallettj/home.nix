{ pkgs, ... }:

{
  fonts.fonts = with pkgs; [
    monaspace

    # Need a nerdfont to get icons
    (nerdfonts.override { fonts = [ "NerdFontsSymbolsOnly" ]; })
  ];
}
