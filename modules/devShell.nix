{
  perSystem =
    { pkgs, ... }:
    {
      # Default devShell bootstraps environment for running nixos-rebuild or
      # home-manager
      devShells.default = (import ../shell.nix { inherit pkgs; }).default;
    };
}
