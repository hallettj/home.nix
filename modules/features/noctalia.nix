{ inputs, ... }:

{
  flake-file.inputs = {
    noctalia = {
      url = "github:noctalia-dev/noctalia";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  flake.modules.nixos.noctalia = { pkgs, ... }: {
    # Required options for Noctalia v5
    networking.networkmanager.enable = true;
    hardware.bluetooth.enable = true;
    services.power-profiles-daemon.enable = true;
    services.upower.enable = true;

    # Allows controlling external monitors - makes Noctalia's external monitor
    # brightness control work.
    services.ddccontrol.enable = true;

    # Noctalia also requires the ddcutil command.
    environment.systemPackages = [ pkgs.ddcutil ];
  };

  flake.modules.homeManager.noctalia = { config, lib, ... }: {
    imports = [ inputs.noctalia.homeModules.default ];

    programs.noctalia = {
      enable = true;
      systemd.enable = true;

      settings = {
        theme = {
          mode = "dark";
          source = "builtin";
          builtin = "Catppuccin";
        };

        bar.default = {
          margin_edge = 0; # space above the bar
          margin_ends = 0; # space to the left and right sides of the bar
          radius = 0;
          shadow = false;

          font_family = "Lexend";

          widget_spacing = 6;

          start = [
            "taskbar"
            "space_l"
            "active_window"
            "space_l"
            "media"
            "audio_visualizer"
          ];
          center = [
            "icon_calendar"
            "date"
            "space_m"
            "icon_clock"
            "clock"
            "space_m"
            "weather"
            "space_m"
            "notifications"
            "privacy"
          ];
          end = [
            "tray"
            "clipboard"
            "space_s"
            "network"
            "space_s"
            "bluetooth"
            "space_s"
            "volume"
            "space_s"
            "brightness"
            "space_s"
            "battery"
            "nightlight"
            "space_s"
            "control-center"
          ];
        };

        widget.bluetooth = {
          hide_when_no_connected_device = true;
          show_label = true;
        };

        widget.date.format = "{:%A, %B %-d}";
        widget.clock.format = "{:%H:%M}";

        widget.icon_calendar = {
          glyph = "calendar-event";
          type = "custom_button";
        };
        widget.icon_clock = {
          glyph = "clock";
          type = "custom_button";
        };

        widget.media.hide_when_no_media = true;

        widget.privacy.hide_inactive = true;

        widget.taskbar = {
          group_by_workspace = true;
          group_single_icon_per_app = true;
          hide_empty_workspaces = true;
          scale = 1.1499999999999999;
          show_workspace_label = false;
        };

        widget.volume = {
          show_label = false;
          scroll_step = 1;
        };

        widget.weather.show_condition = false;

        widget.space_l = {
          length = 40;
          type = "spacer";
        };

        widget.space_m = {
          length = 20;
          type = "spacer";
        };

        widget.space_s = {
          length = 12;
          type = "spacer";
        };

        brightness.enable_ddcutil = true;

        control_center = {
          sidebar_section = "none"; # no panel sidebar when opening bar widgets like clock, network
          shortcuts = [
            { type = "wifi"; }
            { type = "bluetooth"; }
            { type = "caffeine"; }
            { type = "nightlight"; }
            { type = "weather"; }
            { type = "power_profile"; }
          ];
        };

        osd.position = "top_center";

        shell.panel = {
          clipboard_placement = "attached";
          open_near_click_clipboard = true;
          open_near_click_control_center = true;
          open_near_click_session = true;
          session_placement = "centered";
        };

        calendar = {
          enabled = true;
          account.mailbox = {
            name = "Personal Calendar";
            provider = "custom";
            server_url = "https://dav.mailbox.org/";
            type = "caldav";
            username = "jesse@sitr.us";
          };
        };

        desktop_widgets.enabled = false;
        lockscreen.enabled = false;
        lockscreen_widgets.enabled = false;
        location.auto_locate = true;
        nightlight.enabled = true;
        shell.telemetry_enabled = true;
        wallpaper.enabled = false;
      };
    };

    programs.niri.settings.binds =
      let
        msg =
          m: args:
          [
            "noctalia"
            "msg"
            m
          ]
          ++ args;
      in
      {
        "Mod+Slash" = {
          hotkey-overlay.title = "Toggle Do Not Disturb";
          action.spawn = msg "notification-dnd-toggle" [ ];
        };
        "Mod+Ctrl+Slash" = {
          hotkey-overlay.title = "Clear active notifications";
          action.spawn = msg "notification-clear-active" [ ];
        };
        "Mod+Ctrl+Shift+Slash" = {
          hotkey-overlay.title = "Clear notification history";
          action.spawn = msg "notification-clear-history" [ ];
        };

        XF86AudioPlay = {
          allow-when-locked = true;
          action.spawn = msg "media" [ "toggle" ]; # toggle play/pause
        };
        XF86AudioNext.action.spawn = msg "media" [ "next" ];
        XF86AudioPrev.action.spawn = msg "media" [ "previous" ];
        XF86AudioRaiseVolume.action.spawn = msg "volume-up" [ "1" ];
        XF86AudioLowerVolume.action.spawn = msg "volume-down" [ "1" ];
        XF86AudioMute.action.spawn = msg "volume-mute" [ ];
        XF86MonBrightnessUp.action.spawn = msg "brightness-up" [ ];
        XF86MonBrightnessDown.action.spawn = msg "brightness-down" [ ];
      };
  };
}
