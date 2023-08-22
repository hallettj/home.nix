# Jesse's Home Manager config

This is the my personal computer configuration repo. I manage my dot files here,
plus installed packages and various settings.

The entrypoint is [`flake.nix`](./flake.nix) which produces outputs with
configurations for [Home Manager] and for [NixOS].

[Home Manager]: https://github.com/nix-community/home-manager
[NixOS]: https://nixos.org/manual/nixos/stable/

Home Manager can be used on NixOS, or on another system with the Nix package
manager installed. I have the Home Manager config separate from the NixOS
config. (It is possible to use Home Manager as a NixOS module instead.) But
because they are set up through the same flake both configs are locked to the
same nixpkgs revision, and share the same overlays.

The layout is based on the standard template from [Nix Starter Config].

[Nix Starter Config]: https://github.com/Misterio77/nix-starter-configs

## Installation

The flake includes a devshell for bootstrapping Home Manager. As long as Nix is
installed the devshell can be run like this:

    $ NIX_CONFIG="experimental-features = nix-command flakes" nix develop

Then from the devshell run the switch commands below.

## Usage

To install the NixOS config,

    $ sudo nixos-rebuild switch --flake ~/Documents/NixConfig#hostname

To install the Home Manager config,

    $ home-manager switch --flake ~/Documents/NixConfig#username@hostname

## Highlights

My very first reusable Home Manager module adds an option to set a list of Gnome
extension UUIDs, and it automatically installs the necessary packages, and
enables those extensions. Check it out in
[modules/home-manager/gnome-extensions.nix](./modules/home-manager/gnome-extensions.nix).
You can see it in use in my Gnome configuration module,
[home-manager/features/gnome/default.nix](./home-manager/features/gnome/default.nix).
