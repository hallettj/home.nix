{
  flake.modules.homeManager.nix-support =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        nix-tree
      ];
    };
}
