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
    difftastic-nvim = {
      url = "github:clabby/difftastic.nvim";
      flake = false;
    };
    flake-file.url = "github:vic/flake-file";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    git-format-staged = {
      url = "https://flakehub.com/f/hallettj/git-format-staged/4.*";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    git-hooks = {
      url = "github:ysndr/nix-git-hooks/d48aa6c86f9ded84e342e60ebebf8f973a891aa9";
      inputs.nixpkgs.follows = "nixpkgs";
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
      url = "github:noctalia-dev/noctalia";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    oyui = {
      url = "github:hallettj/oyui/override-default-key-bindings";
      inputs.nixpkgs.follows = "nixpkgs";
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
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs = {
        home-manager.follows = "home-manager";
        nixpkgs.follows = "nixpkgs-unstable";
      };
    };
  };
}
