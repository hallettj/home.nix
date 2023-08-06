{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    (lutris.override {
      extraPkgs = pkgs: [
        wine-staging
      ];
    })
    vulkan-tools # just to check that vulkan is set up
  ];
}
