{
  description = "NixOS and Home Manager configuration for Jesse Hallett";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    # Also see the 'unstable-packages' overlay at 'overlays/default.nix'.

    systems.url = "github:nix-systems/default";

    # I have this just to get other inputs to follow the above "systems" input.
    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.systems.follows = "systems";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Replacement for ls
    eza = {
      url = "github:eza-community/eza";
      inputs = {
        flake-utils.follows = "flake-utils";
        nixpkgs.follows = "nixpkgs";
        rust-overlay.follows = "rust-overlay";
      };
    };

    crane = {
      url = "github:ipetkov/crane";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Scrolling window manager
    niri = {
      url = "github:sodiboo/niri-flake";
      inputs = {
        # For some reason flake.lock gets automatically updated with the latest
        # niri-src revision every time I build unless I fix a revision here.
        niri-src.url = "github:YaLTeR/niri/2b5eeb61620363a325a5c76c4a5d25e45f2a6054";
        nixpkgs.follows = "nixpkgs-unstable";
      };
    };

    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
      };
    };

    # Manages version-controlled, encrypted secrets
    sops-nix = {
      url = "github:mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
      inputs.nixpkgs-stable.follows = "nixpkgs";
    };

    # Prebuilt package index - provides comma package
    nix-index-database = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
  };

  outputs = { self, nixpkgs, home-manager, systems, ... }@inputs:
    let
      inherit (self) outputs;
      eachSystem = callback: nixpkgs.lib.genAttrs (import systems) (system: callback (pkgs system));
      flakePath = config: "${config.home.homeDirectory}/Documents/NixConfig";
      pkgs = system: import nixpkgs {
        inherit system;
        overlays = builtins.attrValues self.overlays;
      };
    in
    {
      # Your custom packages
      # Acessible through 'nix build', 'nix shell', etc
      packages = eachSystem (pkgs:
        import ./pkgs { inherit inputs pkgs; }
      );
      # Devshell for bootstrapping
      # Acessible through 'nix develop' or 'nix-shell' (legacy)
      devShells = eachSystem (pkgs:
        import ./shell.nix { inherit pkgs; }
      );

      # Your custom packages and modifications, exported as overlays
      overlays = import ./overlays { inherit inputs; };
      # Reusable nixos modules you might want to export
      # These are usually stuff you would upstream into nixpkgs
      nixosModules = import ./modules/nixos;
      # Reusable home-manager modules you might want to export
      # These are usually stuff you would upstream into home-manager
      homeManagerModules = import ./modules/home-manager;

      # NixOS configuration entrypoint
      # Available through 'nixos-rebuild --flake .#your-hostname'
      nixosConfigurations = {
        yu = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs; };
          modules = [
            # > Our main nixos configuration file <
            ./nixos/yu/configuration.nix
          ];
        };
        battuta = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs; };
          modules = [ ./nixos/battuta/configuration.nix ];
        };
      };

      # Standalone home-manager configuration entrypoint
      # Available through 'home-manager --flake .#your-username@your-hostname'
      homeConfigurations = {
        "jesse@yu" = home-manager.lib.homeManagerConfiguration {
          pkgs = pkgs "x86_64-linux"; # Home-manager requires 'pkgs' instance
          extraSpecialArgs = { inherit flakePath inputs outputs; };
          modules = [
            # > Our main home-manager configuration file <
            ./home-manager/jesse/yu.nix
          ];
        };
        "jesse@battuta" = home-manager.lib.homeManagerConfiguration {
          pkgs = pkgs "x86_64-linux";
          extraSpecialArgs = { inherit flakePath inputs outputs; };
          modules = [ ./home-manager/jesse/battuta.nix ];
        };
      };
    };
}
