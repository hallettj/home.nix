{ pkgs, ... }:

let
  # Use unstable version to get security fix in 1.90.8
  tailscale = pkgs.unstable.tailscale;
in
{
  environment.systemPackages = [ tailscale ];

  services.tailscale = {
    enable = true;
    package = tailscale;
    openFirewall = true;
  };
}

