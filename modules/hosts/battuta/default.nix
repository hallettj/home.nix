{
  inputs,
  lib,
  self,
  ...
}:

{
  flake.nixosConfigurations.battuta = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.modules.nixos.battuta
      inputs.home-manager.nixosModules.home-manager
      {
        home-manager = {
          useGlobalPkgs = true;
          users.jesse = self.modules.homeManager.battuta-jesse;
        };
      }
      { nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux"; }
    ];
  };

  flake.modules.nixos.battuta = {
    imports = with self.modules.nixos; [
      ./_hardware-configuration.nix

      # profiles
      common
      desktop

      # features
      cachix
      claude-anthropic
      determinate
      docker
      gaming
      printing
      tailscale
    ];

    networking.hostName = "battuta";

    # Enable swap on luks
    boot.initrd.luks.devices."luks-4c48c282-3cfc-4a31-a9bd-ae36ddb8fe1b".device =
      "/dev/disk/by-uuid/4c48c282-3cfc-4a31-a9bd-ae36ddb8fe1b";
    boot.initrd.luks.devices."luks-4c48c282-3cfc-4a31-a9bd-ae36ddb8fe1b".keyFile =
      "/crypto_keyfile.bin";

    # On suspend enter S3 deep sleep state instead of shallow s2idle state
    boot.kernelParams = [ "mem_sleep_default=deep" ];

    # Support automatic screen rotation in Niri
    services.iio-niri.enable = true;

    # This value determines the NixOS release from which the default
    # settings for stateful data, like file locations and database versions
    # on your system were taken. It‘s perfectly fine and recommended to leave
    # this value at the release version of the first install of this system.
    # Before changing this value read the documentation for this option
    # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
    system.stateVersion = "23.05"; # Did you read the comment?
  };

  flake.modules.homeManager.battuta-jesse =
    {
      outputs,
      lib,
      pkgs,
      ...
    }:

    {
      imports = with self.modules.homeManager; [
        # profiles
        common
        desktop
      ];

      my-settings = {
        show-battery-status = true;
        show-brightness = true;
      };

      programs.niri.settings = {
        outputs."eDP-1".scale = 2.0;
        input.tablet.map-to-output = "eDP-1";
        input.touch.map-to-output = "eDP-1";
      };

      programs.kitty.extraConfig = ''
        font_size 10.0
      '';

      programs.neovide.settings.font.size = 10;

      programs.swaylock.settings.image = pkgs.fetchurl {
        url = "https://w.wallhaven.cc/full/x6/wallhaven-x6l5vl.jpg"; # Source: https://wallhaven.cc/w/x6l5vl
        hash = "sha256-g2XGek4OqeLbOPAo146Iyfr/AJmQYmYuJ5dD0tVqqbg=";
      };

      programs.waybar.settings.mainBar = {
        # Add battery module to waybar to show charge
        #
        # Using mkAfter orders this setting after the shared waybar configuration so
        # that when configurations are merged "battery" ends up as the last module in
        # the list.
        modules-right = lib.mkAfter [ "battery" ];

        # Specify which network interface to display status of
        network.interface = "wlo1";
      };

      home.useOutOfStoreSymlinks = true;

      home.stateVersion = "23.05"; # Please read the comment before changing.
    };
}
