{ pkgs, ... }:

{
  # programs.steam.enable implicitly enables these options, but let's make them
  # explicit
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
  };

  # Wrappeer program that applies settings to improve game performance
  programs.gamemode.enable = true;

  environment.systemPackages = with pkgs; [
    bottles
    mangohud # Wrapper command that shows system info overlayed over a game

    # Alternative Minecraft launcher. This is installed with a version of
    # openjdk that is compatible with Minecraft, and the launcher is run with
    # a flag that adds the openjdk store path to the launcher's java search
    # path. On updates that change the bundled openjdk store path:
    #
    # - run Prism
    # - open Settings > Java
    # - click Auto-detect...
    # - select the 17.xx option
    prismlauncher

    vulkan-tools # just to check that vulkan is set up
  ];
}
