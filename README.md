# Jesse's NixOS config and dot files

This is the my personal computer configuration repo. I manage my dot files here,
plus installed packages and various settings.
Configuration is almost entirely managed via [NixOS][] extended with the [Home
Manager][] module.

[NixOS]: https://nixos.org/manual/nixos/stable/
[Home Manager]: https://github.com/nix-community/home-manager

This repo uses the "dendritic" pattern. That means that nearly all of the Nix
code is in [flake-parts][] modules. NixOS and Home Manager configurations are
modularized in nested modules inside flake-parts modules. This lets me put, for
example, related NixOS and Home Manager configuration in the same file, together
with relevant flake inputs.

[flake-parts]: https://flake.parts/

## Project Structure

The repo flake uses import-tree to automatically import all `.nix` files under `modules/`, except
files that are prefixed with an underscore (`_`).

My NixOS configuration entrypoints are in `modules/hosts/<hostname>/default.nix`.

Larger portions of reusable configuration are in `modules/profiles/`. For
example all of my NixOS configurations use the `common` profile, and my desktops
and laptops use the `desktop` profile.

Lots of my configuration is modularized into features that can be imported or
disabled individually. These are in `modules/features/`. For example my Neovim
configuration is in `modules/features/neovim/`. That directory contains both the
Home Manager configuration to install Neovim with LSP servers and any other
system stuff I need, plus all of my Neovim configuration files.

I have exported some reusable Home Manager and NixOS modules through flake
outputs. Those are defined in `modules/modules/`.

## Installation

The flake includes a devshell for bootstrapping Home Manager. As long as Nix is
installed the devshell can be run like this:

    $ nix-shell

Then from the devshell run the switch commands below.

## Usage

To install the NixOS config,

    $ sudo nixos-rebuild switch --flake ~/Documents/NixConfig

To install the Home Manager config,

    $ home-manager switch --flake ~/Documents/NixConfig

## Highlights

My very first reusable Home Manager module adds an option to set a list of Gnome
extension UUIDs, and it automatically installs the necessary packages, and
enables those extensions. Check it out in
[modules/modules/gnome-extensions.nix](./modules/modules/gnome-extensions.nix).
You can see it in use in my Gnome configuration module,
[modules/features/gnome/default.nix](./modules/features/gnome/default.nix).
