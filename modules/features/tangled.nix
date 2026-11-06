# Setup to work with my self-hosted Tangled services
{
  flake.modules.nixos.tangled = { pkgs, ... }: {
    # Configure my private binary cache, accessible only via Tailscale. This
    # lets me update my relatively slow laptop by fetching cached CI builds
    # instead of compiling my custom stuff locally.
    nix.settings = {
      substituters = [ "https://attic.ts.sitr.us/plc-l3l63m345yniwsfhfxgffbef" ]; # cache for the upstream Tangled copy of this repo
      trusted-public-keys = [
        "plc-l3l63m345yniwsfhfxgffbef:i2jTcxS9sRwWRWPZSXQpIM+NayfWqXF8w2kFJdA9F0w="
      ];
    };

    # Pin my self-hosted CI service (a Tangled spindle) so that we never try its
    # public IPv4 address. My router has some serious problems with NAT
    # hairpinning, so IPv4 connections from my local network to spindle.sitr.us
    # fail about half the time.
    #
    # IPv6 is listed first, and is the address that actually gets used: there is
    # no NAT on IPv6, so there is no hairpinning to go wrong. Keeping the public
    # address also means browsers see public address space, which matters because
    # the tangled.org web app fetches from spindle.sitr.us. Browsers gate
    # requests from a public page to a private address behind a Local Network
    # Access permission prompt, and the tailnet range (100.64.0.0/10) counts as
    # private.
    #
    # The tailnet address stays as a fallback for IPv4-only networks, and for the
    # case where my ISP rotates the delegated IPv6 prefix and the address below
    # goes stale. Happy Eyeballs falls through to it after a short delay.
    #
    # Not pinning knot.sitr.us to its tailnet address because that would end up
    # connecting to the wrong ssh port. Tailscale connections to that box ssh
    # into the real ssh service, while external connections ssh into the knot
    # service.
    #
    # Firefox needs special configuration to access local network resources. See
    # firefox.nix.
    networking.hosts = {
      "2600:1702:8540:b350:9afe:3eff:fe5e:fe93" = [
        "spindle.sitr.us"
      ];
      "100.121.254.8" = [
        "spindle.sitr.us"
      ];
    };

    environment.systemPackages = [ pkgs.attic-client ];
  };
}
