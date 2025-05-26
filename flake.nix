{
  description = "NixOS and Home Manager configuration for Jesse Hallett";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    # Also see the 'unstable-packages' overlay at 'overlays/default.nix'.

    systems.url = "github:nix-systems/default";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    determinate-nix.url = "https://flakehub.com/f/DeterminateSystems/nix-src/*";

    # Scrolling window manager
    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.niri-stable.follows = "niri-stable";
    };
    niri-stable.url = "github:YaLTeR/niri/v25.05.1";

    # Manages version-controlled, encrypted secrets
    sops-nix = {
      url = "github:mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Prebuilt package index - provides comma package
    nix-index-database = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, systems, ... }@inputs:
    let
      inherit (self) outputs;
      perSystem = callback: nixpkgs.lib.genAttrs (import systems) (system: callback (pkgs system));
      flakePath = config: "${config.home.homeDirectory}/Documents/NixConfig";
      pkgs = system: import nixpkgs {
        inherit system;
        overlays = builtins.attrValues self.overlays;
      };
      extraSpecialArgs = { inherit flakePath inputs outputs; };
    in
    {
      # Your custom packages
      # Acessible through 'nix build', 'nix shell', etc
      packages = perSystem (pkgs:
        import ./pkgs { inherit inputs pkgs; }
      );
      # Devshell for bootstrapping
      # Acessible through 'nix develop' or 'nix-shell' (legacy)
      devShells = perSystem (pkgs:
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
            ./nixos/yu/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                inherit extraSpecialArgs;
                useGlobalPkgs = true;
                users.jesse = import ./home-manager/jesse/yu.nix;
              };
            }
          ];
        };
        battuta = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs; };
          modules = [
            ./nixos/battuta/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                inherit extraSpecialArgs;
                useGlobalPkgs = true;
                users.jesse = import ./home-manager/jesse/battuta.nix;
              };
            }
          ];
        };
      };

      # Standalone home-manager configuration entrypoint
      # Available through 'home-manager --flake .#your-username@your-hostname'
      homeConfigurations = {
        # Currently my home manager configurations are set up through nixos (see
        # nixosConfigurations). But standalone configurations for non-nixos
        # systems can be set up like this:

        # "jesse@yu" = home-manager.lib.homeManagerConfiguration {
        #   inherit extraSpecialArgs;
        #   pkgs = pkgs "x86_64-linux"; # Home-manager requires 'pkgs' instance
        #   modules = [
        #     # > Our main home-manager configuration file <
        #     ./home-manager/jesse/yu.nix
        #   ];
        # };
      };
    };
}
