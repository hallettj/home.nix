# DO-NOT-EDIT. This file was auto-generated using github:vic/flake-file.
# Use `nix run .#write-flake` to regenerate it.
{
  description = "NixOS and Home Manager configuration for Jesse Hallett";

  outputs = inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } (inputs.import-tree ./modules);

  inputs = {
    catppuccin-nushell = {
      url = "github:catppuccin/nushell";
      flake = false;
    };
    determinate-nix.url = "https://flakehub.com/f/DeterminateSystems/nix-src/*";
    flake-file.url = "github:vic/flake-file";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    import-tree.url = "github:vic/import-tree";
    niri-flake = {
      url = "github:LuckShiba/niri-flake/includes";
      inputs = {
        nixpkgs.follows = "nixpkgs-unstable";
        nixpkgs-stable.follows = "nixpkgs";
      };
    };
    nix-index-database = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    noctalia-plugins = {
      url = "github:noctalia-dev/noctalia-plugins";
      flake = false;
    };
    sibling-swap-nvim = {
      url = "github:Wansmer/sibling-swap.nvim";
      flake = false;
    };
    sops-nix = {
      url = "github:mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    systems.url = "github:nix-systems/default";
    telepath-nvim = {
      url = "github:rasulomaroff/telepath.nvim";
      flake = false;
    };
    vim-mcfunction = {
      url = "github:RubixTheSlime/vim-mcfunction/f8ad1bfccb97f8f8e7ee0c52024eac3a8e491a85";
      flake = false;
    };
    wrappers = {
      url = "github:BirdeeHub/nix-wrapper-modules";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
