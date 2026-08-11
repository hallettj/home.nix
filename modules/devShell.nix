{
  perSystem =
    { config, pkgs, ... }:
    {
      devShells.default = pkgs.mkShell {
        inputsFrom = [
          # Default devShell bootstraps environment for running nixos-rebuild or
          # home-manager
          (import ../shell.nix { inherit pkgs; }).default
          config.devShells.git-format-staged
          config.devShells.jj
        ];
      };
    };
}
