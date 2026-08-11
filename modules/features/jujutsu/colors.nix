# Customize jj and jjui colors to be a bit less noisy

{ config, inputs, ... }:

let
  colors = config.palettes.catppuccin-macchiato;
  selected = "#" + colors.surface0;
  text = "#" + colors.text;
  textMuted = "#" + colors.overlay1;
  change = "#" + colors.pink; # jj uses bright magenta, which the kitty catppuccin theme maps to pink
in
{
  flake-file.inputs.jjui-themes = {
    url = "github:vic/tinted-jjui";
    flake = false;
  };

  flake.modules.homeManager.jj-colors = {
    programs.jujutsu.settings.colors = {
      author = {
        fg = textMuted;
        italic = true;
      };
      timestamp = textMuted;

      conflict.italic = true;
      divergent.italic = true;
      empty.italic = true;
      "description placeholder".italic = true;

      "working_copy author" = textMuted;
      "working_copy timestamp" = textMuted;
    };

    programs.jjui.settings.ui.theme = {
      light = "base24-catppuccin-latte";
      dark = "base24-catppuccin-macchiato";
    };

    # Override some of the theme colors
    programs.jjui.settings.ui.colors = {
      selected = {
        bg = selected;
        fg = text;
        bold = true;
      };
      "revisions selected" = {
        bg = selected;
      };
      "revision details selected" = {
        bg = selected;
      };
      "menu selected" = {
        bg = selected;
        fg = text;
      };
      "confirmation selected" = {
        bg = selected;
        fg = text;
      };
      "undo confirmation selected" = {
        bg = selected;
        fg = text;
      };
      "evlog selected" = {
        bg = selected;
        fg = text;
        bold = true;
      };
      "revset completion selected" = {
        bg = selected;
        fg = text;
      };

      "revset completion dimmed".fg = textMuted;
      "revisions dimmed".fg = textMuted;
      "menu dimmed".fg = textMuted;
      "confirmation dimmed".fg = textMuted;
      "undo confirmation dimmed".fg = textMuted;
      "status dimmed".fg = textMuted;

      "revset title" = {
        fg = change;
        bold = true;
      };
      change.fg = change;
      bookmark.fg = change;
    };

    xdg.configFile."jjui/themes".source = "${inputs.jjui-themes}/themes";
  };
}
