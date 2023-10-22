{ config, lib, ... }:

with lib;

let
  cfg = config.gnomeExtensions.paperwm;

  buildWinprop = winprop: pipe winprop [
    (attrsets.filterAttrs (name: value: value != null))
    (attrsets.mapAttrs' (name: value:
      if name == "wm-class" then nameValuePair "wm_class" value
      else if name == "preferred-width" then nameValuePair "preferredWidth" value
      else if name == "scratch-layer" then nameValuePair "scratch_layer" value
      else nameValuePair name value
    ))
    builtins.toJSON
  ];
  buildWinprops = builtins.map buildWinprop;
in
{
  options.gnomeExtensions.paperwm = {
    enable = mkEnableOption "PaperWM, a scrolling window manager extension for Gnome";

    package = mkOption {
      type = types.nullOr types.package;
      default = null;
      description = ''
        Package providing the PaperWM extension.
      '';
    };

    keybindings = mkOption {
      type = with types; nullOr (attrsOf (listOf str));
      default = null;
      description = ''Key bindings. Multiple bindings may be specified for each action. Provide a value of "" to disable a binding.'';
      example = literalExpression {
        live-alt-tab = [ "" ];
        switch-down = [ "<Super>Down" "<Super>t" ];
        switch-left = [ "<Super>Left" "<Super>h" ];
        switch-right = [ "<Super>Right" "<Super>n" ];
        switch-up = [ "<Super>Up" "<Super>c" ];
      };
    };

    winprops = mkOption {
      type = with types; nullOr (listOf (submodule {
        options = {
          wm-class = mkOption { type = nullOr str; default = null; };
          title = mkOption { type = nullOr str; default = null; };
          preferred-width = mkOption {
            type = nullOr str;
            default = null;
            description = ''
              Preferred width. Can be a percent value (e.g. 50%) or pixel value
              (e.g. 500px).

              Note: this property is ignored for windows opened on the scratch
              layer.
            '';
          };
          scratch-layer = mkOption {
            type = nullOr bool;
            description = "Open on floating scratch layer instead of tiled.";
            default = null;
          };
        };
      }));
      default = null;
      description = ''
        Customize handling of specific windows based on the window's class or title.

        Each entry must include a value for either wm_class or title.
      '';
    };

    workspaces = mkOption {
      type = with types; nullOr (listOf (submodule {
        options = {
          name = mkOption {
            type = str;
            description = "Name displayed in the top-left corner of the screen.";
          };
          id = mkOption {
            type = str;
            description = "Unique workspace ID";
            example = literalExpression "f7bf4f04-df01-49d4-90d9-ac80b7e9d3b2";
          };
          color = mkOption {
            type = types.nullOr types.str;
            default = null;
            description = "Background color for the workspace";
            example = literalExpression "rgb(73,64,102)";
          };
        };
      }));
    };
    default = null;
    description = ''
      Configuration for workspaces, including details such as workspace name, and background color.
    '';

    cycle-width-steps = mkOption { type = with types; nullOr (listOf numbers.positive); default = null; };
    horizontal-margin = mkOption { type = with types; nullOr ints.unsigned; default = null; };
    vertical-margin = mkOption { type = with types; nullOr ints.unsigned; default = null; };
    vertical-margin-bottom = mkOption { type = with types; nullOr ints.unsigned; default = null; };
    window-gap = mkOption { type = with types; nullOr ints.unsigned; default = null; };
    show-window-position-bar = mkOption { type = with types; nullOr bool; default = null; };
    topbar-follow-focus = mkOption { type = with types; nullOr bool; default = null; };
  };

  config = mkIf cfg.enable {
    gnomeExtensions = {
      enable = true;
      enabledExtensionUuids = [
        "paperwm@paperwm.github.com"
      ];
      packages = optional (cfg.package != null) cfg.package;
    };

    dconf.settings = {
      # Settings that PaperWM prefers
      "org/gnome/mutter" = {
        workspaces-only-on-primary = false;
        edge-tiling = false;
        attach-modal-dialogs = false;
      };

      "org/gnome/shell/extensions/paperwm" = attrsets.filterAttrs (name: value: value != null) {
        inherit (cfg)
          cycle-width-steps
          horizontal-margin
          vertical-margin
          vertical-margin-bottom
          window-gap
          show-window-position-bar
          topbar-follow-focus;
        winprops = if cfg.winprops != null then buildWinprops cfg.winprops else null;
      };

      "org/gnome/shell/extensions/paperwm/keybindings" = mkIf (cfg.keybindings != null) cfg.keybindings;

      "org/gnome/shell/extensions/paperwm/workspaces" = mkIf (cfg.workspaces != null) {
        list = builtins.map (w: w.id) cfg.workspaces;
      };
    } // (
      # Transform the `workspaces` list into a set of dconf values of the
      # form,
      #
      #     "d13c7071-e870-4014-92a4-709476e62916" = {
      #       name = "Work";
      #       index = 1;
      #       color = "rgb(73,64,102)";
      #     };
      #
      builtins.listToAttrs
        (lists.imap0
          (index: workspace: {
            name = "org/gnome/shell/extensions/paperwm/workspaces/${workspace.id}";
            value = pipe workspace [
              (attrsets.filterAttrs (name: value: value != null))
              (flip builtins.removeAttrs [ "id" ])
              (ws: ws // { inherit index; })
            ];
          })
          (if cfg.workspaces == null then [ ] else cfg.workspaces))
    );
  };
}
