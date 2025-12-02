# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../common.nix
      ../profiles/desktop
      ../features/cachix
      ../features/claude-anthropic
      ../features/determinate.nix
      ../features/docker.nix
      ../features/gaming.nix
      ../features/printing.nix
    ];

  networking.hostName = "battuta";

  # Enable swap on luks
  boot.initrd.luks.devices."luks-4c48c282-3cfc-4a31-a9bd-ae36ddb8fe1b".device = "/dev/disk/by-uuid/4c48c282-3cfc-4a31-a9bd-ae36ddb8fe1b";
  boot.initrd.luks.devices."luks-4c48c282-3cfc-4a31-a9bd-ae36ddb8fe1b".keyFile = "/crypto_keyfile.bin";

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
}
