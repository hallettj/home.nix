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
    # path. I think the way to go to make this work well is to not mess with the
    # java installation path. But on upgrades when the previous openjdk store
    # path is gc'ed it might be necessary to update the java path setting.
    unstable.prismlauncher

    # steam is installed by a nixos module
    vulkan-tools # just to check that vulkan is set up
  ];
}

