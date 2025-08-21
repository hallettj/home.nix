{ pkgs, ... }:

{

  environment.systemPackages = [ pkgs.yubioath-flutter ];
  services.pcscd.enable = true;
  services.udev.packages = [ pkgs.yubikey-personalization ];
}
