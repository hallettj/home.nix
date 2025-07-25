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
      ../features/docker.nix
      ../features/gaming.nix
      ../features/jellyfin.nix
    ];

  networking.hostName = "yu"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  services.avahi.enable = true;

  # Connect to VPN by running $ mullvad connect
  services.mullvad-vpn.enable = true;

  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = [ "jesse" ];
}
