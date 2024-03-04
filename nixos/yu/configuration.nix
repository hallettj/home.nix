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
      ../features/niri.nix
      ../features/vpn
    ];

  networking.hostName = "yu"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  services.printing.drivers = with pkgs; [
    cups-brother-hll2350dw
  ];

  virtualisation.docker.enable = true;

  services.clamav = {
    daemon.enable = true;
    updater.enable = true;
    updater.interval = "daily";
  };

  services.avahi = {
    enable = true;
    # domainName = "attlocal.net"; # the AT&T router feels a need to make my network non-standard
    publish = {
      enable = true;
      addresses = true;
      domain = true;
      hinfo = true;
      userServices = true;
      workstation = true;
    };
    extraServiceFiles.smb = ''
      <?xml version="1.0" standalone='no'?><!--*-nxml-*-->
      <!DOCTYPE service-group SYSTEM "avahi-service.dtd">
      <service-group>
        <name replace-wildcards="yes">%h</name>
        <service>
          <type>_smb._tcp</type>
          <port>445</port>
        </service>
      </service-group>
    '';
  };

  # Samba server to share files over local network
  services.samba = {
    enable = true;
    securityType = "user";
    extraConfig = ''
      guest account = nobody
      map to guest = bad user
      bind interfaces only = yes
      interfaces = lo enp5s0 wlp4s0
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
