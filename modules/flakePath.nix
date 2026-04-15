# Fix flake filesystem location to make out-of-store symlinks work
{lib, ...}:

{
  options.flakePath = lib.mkOption {
    description = "Fixed filesystem path of NixOS & Home Manager flake";
    default = "/home/jesse/home.nix";
    type = lib.types.externalPath;
  };

  config.flakePath = "/home/jesse/Documents/NixConfig";
}
