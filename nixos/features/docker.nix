{ ... }:

{
  virtualisation.docker.enable = true;

  # Docker containers access host services via `host-gateway` - but this doesn't
  # work out of the box on NixOS. This rule fixes the problem by configuring the
  # host firewall to acceput all traffic from Docker bridge interfaces (all
  # interfaces with names that begin with "br-").
  # networking.firewall.trustedInterfaces = [ "br-+" ];

  # Or try https://stackoverflow.com/questions/54058515/allow-traffic-from-localhost-to-docker-container

  # Allow network traffic between docker containers via host-gateway.
  #
  # Docker containers seem to use IP addresses 172.16.x.x-172.31.x.x which is
  # 172.16.0.0/12 in CIDR notation. And 172.17.0.1 is the address for Docker's
  # gateway for its bridge network.
  #
  # This config is thanks to
  # https://discourse.nixos.org/t/docker-container-not-resolving-to-host/30259/8
  networking.firewall.extraCommands = ''
    iptables -I INPUT 1 -s 172.16.0.0/12 -p tcp -d 172.17.0.1 -j ACCEPT
    iptables -I INPUT 2 -s 172.16.0.0/12 -p udp -d 172.17.0.1 -j ACCEPT
  '';
}
