{ lib, ... }:

{
  imports = [
    ../../features/_1password.nix
    ../../features/fonts
    ../../features/niri.nix
  ];

  # Setup keyfile - copies /crypto_keyfile.bin to same path in initrd
  boot.initrd.secrets = {
    "/crypto_keyfile.bin" = null;
  };

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    nssmdns6 = true; # might lead to long timeouts since many hosts do not publish mdns over IPv6
    publish = {
      enable = true;
      addresses = true;
    };
  };

  services.blueman.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver = {
    xkb.layout = "us";
    xkb.variant = "";
  };

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Set your time zone.
  time.timeZone = lib.mkForce null; # allow TZ to be set by desktop user
}

