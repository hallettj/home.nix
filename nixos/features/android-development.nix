{ pkgs, ... }:

{
  # Configure USB permissions so that adb can connect to phone.
  programs.adb.enable = true;
  services.udev.extraRules =
    let
      idVendor = "18d1"; # Google
      idProduct = "4ee7"; # Pixel 8
    in
    ''
      SUBSYSTEM=="usb", ATTR{idVendor}=="${idVendor}", MODE="[]", GROUP="adbusers", TAG+="uaccess"
      SUBSYSTEM=="usb", ATTR{idVendor}=="${idVendor}", ATTR{idProduct}=="${idProduct}", SYMLINK+="android_adb"
      SUBSYSTEM=="usb", ATTR{idVendor}=="${idVendor}", ATTR{idProduct}=="${idProduct}", SYMLINK+="android_fastboot"
    '';
  users.users.jesse.extraGroups = [ "adbusers" ];

  # Open ports for Expo
  networking.firewall.allowedTCPPorts = [
    8081
    19000
  ];
}
