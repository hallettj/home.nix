{ pkgs, ... }:

{
  # programs.steam.enable implicitly enables these options, but let's make them
  # explicit
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  programs.steam = {
    enable = true;
    localNetworkGameTransfers.openFirewall = true;
  };

  environment.systemPackages = with pkgs; [
    bottles

    (unstable.lutris.override {
      extraPkgs = pkgs: [
        pkgs.wineWowPackages.stagingFull
        pkgs.winetricks
      ];
    })

    # Alternative Minecraft launcher. This is installed with a version of
    # openjdk that is compatible with Minecraft, and the launcher is run with
    # a flag that adds the openjdk store path to the launcher's java search
    # path. On updates that change the bundled openjdk store path:
    #
    # - run Prism
    # - open Settings > Java
    # - click Auto-detect...
    # - select the 17.xx option
    (prismlauncher.overrideAttrs (attrs: {
      # make the latest JDK available - Minecraft 1.21 wants jdk21
      nativeBuildInputs = attrs.nativeBuildInputs ++ [ jdk ];
    }))

    vulkan-tools # just to check that vulkan is set up
  ];
}
