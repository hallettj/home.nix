{ ... }:

{
  nix.settings = {
    substituters = [ "https://cache.garnix.io?priority=50" ]; # cache.nixos.org priority is 40 so it will be hit first
    trusted-public-keys = [ "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g=" ];
  };
}
