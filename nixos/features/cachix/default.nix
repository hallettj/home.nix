{ lib, ... }:

let
  folder = ./caches;
  toImport = name: value: folder + ("/" + name);
  filterCaches = key: value: value == "regular" && lib.hasSuffix ".nix" key;
in
{
  imports = lib.mapAttrsToList toImport (lib.filterAttrs filterCaches (builtins.readDir folder));
  nix.settings.substituters = [ "https://cache.nixos.org/" ];
}
