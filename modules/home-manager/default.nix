# Add your reusable home-manager modules to this directory, on their own file (https://nixos.wiki/wiki/Module).
# These should be stuff you would like to share with others, not your personal configurations.

{ home-manager-unstable }:
{
  gnomeExtensions = import ./gnome-extensions.nix;
  paperwm = import ./paperwm.nix;
  screen-type = import ./screen-type.nix;
  carapace = import "${home-manager-unstable}/modules/programs/carapace.nix";
}
