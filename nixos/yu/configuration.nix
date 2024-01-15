# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ pkgs, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../common.nix
      ../features/vpn
    ];

  networking.hostName = "yu"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  services.printing.drivers = with pkgs; [
    cups-brother-hll2350dw
  ];

  virtualisation.docker.enable = true;

  # Samba server to share files over local network
  services.samba = {
    enable = true;
    securityType = "user";
    extraConfig = ''
      guest account = nobody
      map to guest = bad user
    '';
    shares = {
      public = {
        path = "/srv/public";
        browseable = "yes";
        "read only" = true;
        "guest ok" = "yes";
      };
    };
  };

  # Allows browsing Samba shares in Gnome
  services.gvfs.enable = true;
}
