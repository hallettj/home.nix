# Jesse's Home Manager config

This is the my personal computer configuration repo. I manage my dot files here,
plus installed packages and various settings.

This config uses [Home Manager](https://github.com/nix-community/home-manager).
It can be used on NixOS, or on another system with the Nix package manager
installed. I have opted for a flake-based standalone config which means that (at
least for now) my Home Manager config is separate from my NixOS config.

## Highlights

My very first reusable Home Manager module adds an option to set a list of Gnome
extension UUIDs, and it automatically installs the necessary packages, and
enables those extensions. Check it out in
[gnome/gnome-extensions.nix](./gnome/gnome-extensions.nix). You can see it in
use in my Gnome configuration module, [gnome/default.nix](./gnome/default.nix).
