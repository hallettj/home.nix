{ lib, ... }:

{
  options.home.useOutOfStoreSymlinks = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = ''
      If set to true then some features in this repo will use out-of-store symlinks that require the repo to be checked out to ~/Documents/NixConfig to work correctly.

      Use the default value of false if importing modules in another configuration, or if this repo is checked out to a different path.
    '';
  };
}
