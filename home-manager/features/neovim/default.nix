{ config, flakePath, pkgs, ... }:

let
  # Out-of-store symlinks require absolute paths when using a flake config. This
  # is because relative paths are expanded after the flake source is copied to
  # a store path which would get us read-only store paths.
  dir = "${flakePath config}/home-manager/features/neovim";
in
{
  xdg.configFile.nvim = {
    source = config.lib.file.mkOutOfStoreSymlink "${dir}/nvim-config";
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    withPython3 = true;
    extraPackages = with pkgs; [
      fd
      gh # for github integration
      ripgrep # used by obsidian.nvim and other plugins
      wl-clipboard # used by obsidian.nvim to interact with clipboard

      # needed to compile fzf-native for telescope-fzf-native.nvim
      gcc
      gnumake

      # language servers
      deno
      lua-language-server
      nil # Nix LSP
      nls # Nickel LSP
      nodePackages.bash-language-server
      nodePackages.typescript-language-server
      shellcheck # called by bash-language-server

      nixpkgs-fmt # I have nil configured to call this for formatting
    ];
  };

  home.sessionVariables = {
    # This is used to get lldb for debugging Rust code. Install lldb via this
    # vscode extension that apparently does something special, and pass the
    # extension path to neovim via environment variable.
    VSCODE_LLDB_PATH = "${pkgs.vscode-extensions.vadimcn.vscode-lldb}/share/vscode/extensions/vadimcn.vscode-lldb";

    # Disable the top window bar in Neovide
    NEOVIDE_FRAME = "none";

    # I just don't want extra UI anywhere
    NVIM_GTK_NO_HEADERBAR = "1";
  };

  home.packages = with pkgs; [
    unstable.neovide
  ];
}
