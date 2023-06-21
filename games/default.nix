{ config, pkgs, inputs, ... }:

{
  home.packages = with pkgs; [
    (lutris.override {
      extraPkgs = lutrisPkgs: [
        wine
        inputs.nix-gaming.packages.${pkgs.system}.wine-ge
      ];
    })
    steam
    vulkan-tools # just to check that vulkan is set up
  ];
}
