flakeParts@{ inputs, ... }:

let
  flakePath = flakeParts.config.flakePath;
in
{
  flake-file.inputs.catppuccin-nushell = {
    url = "github:catppuccin/nushell";
    flake = false;
  };

  flake.modules.homeManager.nushell =
    {
      config,
      lib,
      pkgs,
      ...
    }:

    let
      # Out-of-store symlinks require absolute paths when using a flake config. This
      # is because relative paths are expanded after the flake source is copied to
      # a store path which would get us read-only store paths.
      useOutOfStoreSymlinks =
        if builtins.hasAttr "useOutOfStoreSymlinks" config.home then
          config.home.useOutOfStoreSymlinks
        else
          false;

      nupkgs = pkgs;
      dir = "${flakePath}/modules/features/nushell";
      nu_scripts = nupkgs.nu_scripts;
      nuModule = nupkgs.callPackage ./_writeNushellModule.nix { };

      env_nu = if useOutOfStoreSymlinks then "${dir}/env.nu" else ./env.nu;
      config_nu = if useOutOfStoreSymlinks then "${dir}/config.nu" else ./config.nu;
      eza_nu = if useOutOfStoreSymlinks then "${dir}/config.d/eza.nu" else ./config.d/eza.nu;
    in
    {
      programs.nushell = {
        enable = true;
        package = nupkgs.nushell;
        envFile.text = "source ${env_nu}";
        configFile.text = /* nu */ ''
          use ${nu_scripts}/share/nu_scripts/modules/filesystem/expand.nu
          use ${nu_scripts}/share/nu_scripts/modules/nix/nix.nu *
          use ${nuModule ./nushell-modules/boot-to.nu}
          use ${nuModule ./nushell-modules/webcam-temp.nu}
          source ${config_nu}
          source ${eza_nu}
          source ${inputs.catppuccin-nushell}/themes/catppuccin_macchiato.nu
        '';

        # Duplicate home.sessionVariables in nushell - this is not automatic as
        # of Home Manager 26.05.
        #
        # This doesn't correctly handle cases where variables include
        # expressions meant to be expanded by bash. Fortunately I don't have any
        # of those in my environment.
        # See https://github.com/nix-community/home-manager/issues/4313#issuecomment-3667548466
        environmentVariables = builtins.mapAttrs (
          name: value: builtins.toString value
        ) config.home.sessionVariables;
      };

      programs.carapace = {
        enable = true;
        enableNushellIntegration = true;
      };

      # Replacement for ls
      programs.eza = {
        enable = true;
        enableNushellIntegration = true;
      };

      # Change directories with fuzzy search
      programs.zoxide.enable = true;

      home.packages = with pkgs; [
        efibootmgr # for boot-to script
        v4l-utils # for webcam temperature control
      ];
    };
}
