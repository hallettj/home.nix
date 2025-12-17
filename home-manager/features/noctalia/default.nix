{
  config,
  inputs,
  lib,
  ...
}:

let
  cfg = config.my-settings;
in
{
  imports = [
    inputs.noctalia.homeModules.default
  ];

  options.my-settings = {
    show-battery-status = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Should system battery status be displayed in the Noctalia bar?";
    };
    show-brightness = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Should a brightness widget be displayed in the Noctalia bar?";
    };
  };

  config.programs.noctalia-shell = {
    enable = true;
    systemd.enable = true;
    settings = {
      colorSchemes.predefinedScheme = "Catppuccin";

      general = {
        enableShadows = false;
        dimmerOpacity = 0.5;
      };

      ui = {
        fontDefaultScale = 1.1;
        fontFixedScale = 1.1;
        panelBackgroundOpacity = 1;
        settingsPanelMode = "window";
      };

      bar = {
        density = "comfortable";
        outerCorners = false;
        showCapsule = false;
        widgets = {
          left = [
            {
              id = "Workspace";
              labelMode = "none";
            }
            {
              id = "MediaMini";
              maxWidth = 1000;
              useFixedWidth = false;
            }
            {
              id = "ActiveWindow";
              maxWidth = 1000;
              useFixedWidth = true; # prevents distracting animations on width changes
            }
          ];
          center = [
            {
              id = "Clock";
              usePrimaryColor = false;
            }
            { id = "NotificationHistory"; }
          ];
          right = builtins.filter (e: e != null) [
            {
              id = "Tray";
              drawerEnabled = false;
            }
            (
              if cfg.show-battery-status then
                {
                  id = "Battery";
                  displayMode = "alwaysShow";
                  warningThreshold = 30;
                }
              else
                null
            )
            {
              id = "Battery";
              deviceNativePath = "/org/bluez/hci0/dev_EC_A5_35_3B_B8_C8";
              displayMode = "alwaysShow";
              warningThreshold = 30;
            }
            (if cfg.show-brightness then { id = "Brightness"; } else null)
            { id = "WiFi"; }
            {
              id = "Volume";
              displayMode = "alwaysHide";
            }
            {
              id = "ControlCenter";
              useDistroLogo = true;
            }
          ];
        };
      };

      audio.volumeStep = 1;

      location = {
        name = "Castro Valley, CA";
        firstDayOfWeek = 1;
      };

      nightLight.enabled = true;

      wallpaper.enabled = false;
    };
  };
}
