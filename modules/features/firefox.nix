{
  flake.modules.homeManager.firefox =
    { config, ... }:
    {
      programs.firefox = {
        enable = true;
        configPath = "${config.xdg.configHome}/mozilla/firefox"; # default as of Home Manager 26.05
        profiles.default.settings = {
          # Full-screen does not actually make the window full screen. I use this
          # setting to abuse full-screen mode to hide the navigation and tab bars.
          "full-screen-api.ignore-widgets" = true;
        };
        profiles.video.id = 1;
      };
    };
}
