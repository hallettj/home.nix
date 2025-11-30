{ pkgs, ... }:

let
  tailscale = pkgs.tailscale;
in
{
  environment.systemPackages = [ tailscale ];

  services.tailscale = {
    enable = true;
    package = tailscale;
    openFirewall = true;
  };
}

