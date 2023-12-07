{ pkgs, ... }:

{
  home.packages = with pkgs; [
    (lutris.override {
      extraPkgs = pkgs: [
        wine-staging
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
    prismlauncher

    # steam is installed by a nixos module
    vulkan-tools # just to check that vulkan is set up
  ];
}

