{
  inputs,
  lib,
  self,
  ...
}:

{
  flake.nixosConfigurations.yu = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.modules.nixos.yu
      inputs.home-manager.nixosModules.home-manager
      {
        home-manager = {
          useGlobalPkgs = true;
          users.jesse = self.modules.homeManager.yu-jesse;
        };
      }
      { nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux"; }
    ];
  };

  flake.modules.nixos.yu =
    { ... }:
    {
      imports = with self.modules.nixos; [
        ./_hardware-configuration.nix

        # profiles
        common
        desktop

        # features
        android-development
        cachix
        claude-anthropic
        determinate
        docker
        gaming
        printing
        tailscale
      ];

      networking.hostName = "yu"; # Define your hostname.
      # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

      # Connect to VPN by running $ mullvad connect
      services.mullvad-vpn.enable = true;

      # Allows controlling external monitors - makes Noctalia's external monitor
      # brightness control work.
      services.ddccontrol.enable = true;

      # This value determines the NixOS release from which the default
      # settings for stateful data, like file locations and database versions
      # on your system were taken. It‘s perfectly fine and recommended to leave
      # this value at the release version of the first install of this system.
      # Before changing this value read the documentation for this option
      # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
      system.stateVersion = "23.05"; # Did you read the comment?
    };

  flake.modules.homeManager.yu-jesse =
    { pkgs, ... }:
    {
      imports = with self.modules.homeManager; [
        # profiles
        common
        desktop

        # features
        godot
        obs
        vscode
      ];

      my-settings.show-brightness = true;
      screen-type.aspect-ratio = "ultrawide";

      programs.niri.settings.outputs."DP-1" = {
        scale = 1.25;
        variable-refresh-rate = true;
      };

      programs.kitty.extraConfig = ''
        font_size 10.0
      '';

      programs.neovide.settings.font.size = 10;

      programs.swaylock.settings.image = pkgs.fetchurl {
        url = "https://w.wallhaven.cc/full/md/wallhaven-mdyvvm.jpg"; # Source: https://wallhaven.cc/w/mdyvvm
        hash = "sha256-1JtqfH1htLqprk3W8pkdscT/5w5lYflsO+f20m7dmbg=";
      };

      home.packages = with pkgs; [
        gparted
        love # 2D game engine
        parted
        shotcut
      ];

      home.useOutOfStoreSymlinks = true;

      home.stateVersion = "23.05"; # Please read the comment before changing.
    };
}
