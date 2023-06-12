{ config, pkgs, ... }:

let
  # Each Gnome extension has an email-like uuid. Gnome uses these uuids to track
  # which of the installed extensions are enabled.
  #
  # There are a couple of ways to find the uuid. If you look at the source for
  # an extension it should have a `metadata.json` with a `uuid` field. Or on
  # a gnome.extensions.org page you can look at the HTML source and find a div
  # with an attribute like, `data-uuid="..."`.
  enabledExtensions = [
    "advanced-alt-tab@G-dH.github.com"
    "appindicatorsupport@rgcjonas.gmail.com"
    "gtktitlebar@velitasali.github.io"
    "horizontal-workspace-indicator@tty2.io"
    "paperwm@hedning:matrix.org"
    "runcat@kolesnikov.se"
  ];

  # Search through `pkgs.gnomeExtensions` for packages for each extension that
  # we want. Packages are found by checking the package's `extensionUuid`
  # attribute against the list of enabled extension uuids.
  enabledExtensionPackages =
    let
      allExtensionPackages = builtins.attrValues pkgs.gnomeExtensions;
      isEnabled = extensionPackage:
        let p = builtins.tryEval extensionPackage; # tryEval because some packages evaluate to deprecation errors
        in
        p.success && builtins.isAttrs p.value && builtins.hasAttr "extensionUuid" p.value &&
        builtins.any (e: p.value.extensionUuid == e) enabledExtensions;
    in
    checkForMissing (builtins.filter isEnabled allExtensionPackages);

  checkForMissing = extensionPackages:
    let
      noPackagesMatchUuid = uuid: !(builtins.any (p: p.extensionUuid == uuid) extensionPackages);
      missingUuids = builtins.filter noPackagesMatchUuid enabledExtensions;
    in
    if missingUuids != [ ] then abort "Could not find packages for some Gnome extensions: ${builtins.toString missingUuids}"
    else extensionPackages;
in
{
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };

    # Settings that PaperWM prefers
    "org/gnome/mutter" = {
      workspaces-only-on-primary = false;
      edge-tiling = false;
      attach-modal-dialogs = false;
    };

    "org/gnome/shell" = {
      disable-user-extensions = false;
      enabled-extensions = enabledExtensions;
    };

    "org/gnome/shell/extensions/paperwm/keybindings" = {
      "switch-left" = [ "<Super>Left" "<Super>h" ];
      "switch-right" = [ "<Super>Right" "<Super>n" ];
      "switch-up" = [ "<Super>Up" "<Super>c" ];
      "switch-down" = [ "<Super>Down" "<Super>t" ];
      "toggle-scratch" = [ "<Shift><Super>quotedbl" ]; # move window into or out of scratch layer
      "toggle-scratch-layer" = [ "<Super>apostrophe" ];
    };
  };

  home.packages = enabledExtensionPackages;
}
