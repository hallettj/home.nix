{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.my-settings;

  plugin-settings.privacy-indicator.hideInactive = true;

  # Create a derivation based on inputs.noctalia-plugins, but merge custom
  # settings from `plugin-settings` with default settings for each plugin, and
  # write the result to a `settings.json` file for each plugin.
  plugins = pkgs.runCommand "noctalia-plugins" { } ''
    cp -r "${inputs.noctalia-plugins}" "$out"
    chmod -R +w "$out"
    ${lib.concatStrings (
      lib.mapAttrsToList (
        pluginName: settings:
        let
          settingsJson = pkgs.writeText "${pluginName}-settings.json" (builtins.toJSON settings);
        in
        ''
          ${lib.getExe pkgs.jq} --slurpfile customizations ${settingsJson} \
            '.metadata.defaultSettings * $customizations[0]' \
            "$out/${pluginName}/manifest.json" > "$out/${pluginName}/settings.json"
        ''
      ) plugin-settings
    )}
  '';
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
      description = "Should a brightness widget be displayed in the Noctalia control center?";
    };
  };

  # Referenced in my swayidle module
  config.my-settings.lock-screen-command = "${lib.getExe config.programs.noctalia-shell.package} ipc call lockScreen lock";

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
              showApplications = true;
              hideUnoccupied = true;
            }
            {
              id = "Spacer";
              width = 20;
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
            { id = "plugin:privacy-indicator"; }
          ];
          right = builtins.filter (e: e != { }) [
            { id = "plugin:network-indicator"; }
            {
              id = "Spacer";
              width = 20;
            }
            {
              id = "Tray";
              drawerEnabled = false;
            }
            (lib.optionalAttrs cfg.show-battery-status {
              id = "Battery";
              displayMode = "alwaysShow";
              warningThreshold = 30;
            })
            {
              id = "Battery";
              deviceNativePath = "/org/bluez/hci0/dev_EC_A5_35_3B_B8_C8";
              displayMode = "alwaysShow";
              warningThreshold = 30;
            }
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

      audio = {
        volumeStep = 1;
        preferredPlayer = "Qobuz";
      };
      brightness = {
        brightnessStep = 5;
        enableDdcSupport = true;
        enforceMinimum = true;
      };

      controlCenter.cards = builtins.filter (e: e != { }) [
        {
          enabled = true;
          id = "profile-card";
        }
        {
          enabled = true;
          id = "shortcuts-card";
        }
        {
          enabled = true;
          id = "audio-card";
        }
        (lib.optionalAttrs cfg.show-brightness {
          enabled = true;
          id = "brightness-card";
        })
        {
          enabled = true;
          id = "weather-card";
        }
        {
          enabled = true;
          id = "media-sysmon-card";
        }
      ];

      dock.enabled = false;
      location = {
        name = "Castro Valley, CA";
        firstDayOfWeek = 1;
      };
      nightLight.enabled = true;
      wallpaper.enabled = false;
    };
  };

  config.xdg.configFile = {
    "noctalia/plugins.json".text = builtins.toJSON {
      sources = [
        {
          enabled = true;
          name = "Official Noctalia Plugins";
          url = "https://github.com/noctalia-dev/noctalia-plugins";
        }
      ];
      states = {
        network-indicator.enabled = true;
        privacy-indicator.enabled = true;
      };
      version = 1;
    };

    "noctalia/plugins/network-indicator".source = "${plugins}/network-indicator";
    "noctalia/plugins/privacy-indicator".source = "${plugins}/privacy-indicator";
  };
}
