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

          # Firefox 153+ enforces Local Network Access (LNA): a page served from
          # a public origin may not fetch from a private address without an
          # explicit permission grant. The tangled.org web app fetches from my
          # self-hosted spindle.sitr.us, which modules/features/tangled.nix may
          # resolve to a tailnet address (100.64.0.0/10 is private as far as LNA
          # is concerned). Skip the check for my own domain. Matched against both
          # the requesting site and the target, so this covers either side.
          "network.lna.skip-domains" = "sitr.us,*.sitr.us";
        };
        profiles.video.id = 1;
      };
    };
}
