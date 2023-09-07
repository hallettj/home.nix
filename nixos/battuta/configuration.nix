# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../common
      ../features/nixbuild
    ];

  # Enable swap on luks
  boot.initrd.luks.devices."luks-4c48c282-3cfc-4a31-a9bd-ae36ddb8fe1b".device = "/dev/disk/by-uuid/4c48c282-3cfc-4a31-a9bd-ae36ddb8fe1b";
  boot.initrd.luks.devices."luks-4c48c282-3cfc-4a31-a9bd-ae36ddb8fe1b".keyFile = "/crypto_keyfile.bin";

  networking.hostName = "battuta";

  virtualisation.docker.enable = true;

  # Support automatic screen rotation & ambient light adjustment in Gnome.
  hardware.sensor.iio.enable = true;
}
