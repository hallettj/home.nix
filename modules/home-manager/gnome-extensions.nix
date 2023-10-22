# Enables Gnome extensions identified by UUID. Automatically loads packages for
# each extension from nixpkgs, but you may provide custom packages for specific
# extensions.
#
# For usage examples see home-manager/features/gnome/default.nix and
# modules/home-manager/paperwm.nix
{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.gnomeExtensions;

  # Search through `pkgs.gnomeExtensions` for packages for each extension that
  # we want. Packages are found by checking the package's `extensionUuid`
  # attribute against the list of enabled extension uuids.
  enabledExtensionPackages =
    let
      allExtensionPackages = builtins.attrValues pkgs.gnomeExtensions;

      uuidMatches = extensionPackage:
        let packageUuid = extensionUuid extensionPackage;
        in
        uuid: packageUuid == uuid;

      hasPackageOverride = uuid: builtins.any (package: uuidMatches package uuid) cfg.packages;

      uuidsWithoutOverride = builtins.filter (uuid: !(hasPackageOverride uuid)) cfg.enabledExtensionUuids;

      isEnabled = extensionPackage:
        builtins.any (uuidMatches extensionPackage) uuidsWithoutOverride;
    in
    builtins.filter isEnabled allExtensionPackages;

  extensionUuid = extensionPackage:
    let p = builtins.tryEval extensionPackage; # tryEval because some packages evaluate to deprecation errors
    in
    if p.success && builtins.isAttrs p.value && builtins.hasAttr "extensionUuid" p.value
    then p.value.extensionUuid
    else null;

  checkForMissing = extensionPackages:
    let
      noPackagesMatchUuid = uuid: !(builtins.any (p: extensionUuid p == uuid) extensionPackages);
      missingUuids = builtins.filter noPackagesMatchUuid cfg.enabledExtensionUuids;
    in
    if missingUuids != [ ] then abort "Could not find packages for some Gnome extensions: ${builtins.toString missingUuids}"
    else extensionPackages;

  checkForExtensionUuids = extensionPackages:
    let
      isAttributeMissing = extensionPackage: builtins.isNull (extensionUuid extensionPackage);
      packagesMissingAttribute = builtins.filter isAttributeMissing extensionPackages;
    in
    if packagesMissingAttribute != [ ] then
      builtins.throw "Some of the given extension packages do not have an `extensionUuid` attribute: ${buitins.toString packagesMissingAttribute}"
    else extensionPackages;
in
{
  options.gnomeExtensions = {
    enable = mkEnableOption "gnome-extensions";

    enabledExtensionUuids = mkOption {
      type = types.listOf types.str;
      description = ''
        Provide a list of Gnome extension UUID strings. These will be set as the
        list of enabled extensions. The corresponding packages will
        automatically be installed from pkgs.gnomeExtensions.

        Each Gnome extension has an email-like UUID. Gnome uses these UUIDs to
        track which of the installed extensions are enabled. There are a couple of
        ways to find the UUID. If you look at the source for an extension it
        should have a `metadata.json` with a `uuid` field. Or on
        a gnome.extensions.org page you can look at the HTML source and find a div
        with an attribute like, `data-uuid="..."`.
      '';
    };

    packages = mkOption {
      type = types.listOf types.package;
      default = [ ];
      description = ''
        Any extension packages listed here will be used instead of packages from
        pkgs.gnomeExtensions.

        Each package must have an `extensionUuid` attribute that matches one of
        the UUIDs listed in the `enabledExtensionUuids` option. If you build
        a package using `stdenv.mkDerivation` then you can do this by passing an
        attribute called `passthru.extensionUuid` to `mkDerivation`.
      '';
    };
  };

  config = mkIf cfg.enable {
    dconf.settings = {
      "org/gnome/shell" = {
        disable-user-extensions = false;
        enabled-extensions = cfg.enabledExtensionUuids;
      };
    };
    home.packages = checkForMissing (enabledExtensionPackages ++ checkForExtensionUuids cfg.packages);
  };
}

