{ config, pkgs, ... }:

# Run programs or switch to open windows
{
  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
    font = "mono 18"; # columns don't align with proportional fonts
    terminal = "${config.programs.kitty.package}/bin/kitty";
    extraConfig = {
      combi-display-format = "{text}";
      show-icons = true;

      # Available placeholders are {w}, {t}, {n}, {c}, {r}
      # For a fancier display that includes app names try,
      #
      #     "{t} <span weight='light' size='small'><i>{c}</i></span>"
      #
      window-format = "{t}";
    };
  };
}
