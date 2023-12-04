{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.niri;
in
{
  options.programs.niri = {
    enable = mkEnableOption "Niri, a scrollable-tiling Wayland compositor.";

    package = mkOption {
      type = types.package;
      default = pkgs.niri;
      defaultText = literalExpression "pkgs.niri via overlay";
    };

    extraPackages = mkOption {
      type = with types; listOf package;
      default = with pkgs; [ alacritty ];
      defaultText = literalExpression ''
        with pkgs; [ alacritty ];
      '';
      description = lib.mdDoc ''
        Extra packages to help provide a fully-featured desktop environment.

        - alacritty is included because the default configuration includes a key binding to launch it
      '';
    };
  };

  config = mkIf cfg.enable {
    environment = {
      systemPackages = [ cfg.package ] ++ cfg.extraPackages;
    };

    # security.polkit.enable = true;
    hardware.opengl.enable = mkDefault true;
    fonts.enableDefaultPackages = mkDefault true;
    programs.xwayland.enable = mkDefault true;

    # To make a Niri session available if a display manager like SDDM is enabled:
    services.xserver.displayManager.sessionPackages = [ cfg.package ];

    systemd.user.services.niri = {
      description = "A scrollable-tiling Wayland compositor";
      bindsTo = [ "graphical-session.target" ];
      before = [ "graphical-session.target" ];
      wants = [ "graphical-session-pre.target" "xdg-desktop-autostart.target" ];
      after = [ "graphical-session-pre.target" "xdg-desktop-autostart.target" ];
      serviceConfig = {
        Type = "notify";
        ExecStart = "${cfg.package}/bin/niri";
      };
    };
  };
}
