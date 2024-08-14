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
      ripgrep # used by obsidian.nvim, smart-open and other plugins
      wl-clipboard # used by obsidian.nvim to interact with clipboard

      # needed to compile fzf-native for telescope-fzf-native.nvim
      gcc
      gnumake

      # needed by luarocks
      lua
      python3

      # language servers
      deno
      lua-language-server
      nil # Nix LSP
      nodePackages.bash-language-server
      nodePackages.typescript-language-server
      ormolu # formatting for haskell files
      shellcheck # called by bash-language-server

      # Rust support
      lldb # debug adapter
      graphviz # to render crate graphs from rustaceanvim

      nixpkgs-fmt # I have nil configured to call this for formatting
    ];
  };

  home.packages = with pkgs; [
    neovide

    # language servers
    nickel-lang-cli # to pair with the LSP
    nickel-lang-lsp # Nickel LSP from my overlay
    vscode-langservers-extracted
  ];

  home.sessionVariables = {
    # Disable the top window bar in Neovide
    NEOVIDE_FRAME = "none";

    # I just don't want extra UI anywhere
    NVIM_GTK_NO_HEADERBAR = "1";

    # Read by kkharji/sqlite.lua plugin which is a dependency of smart-open
    SQLITE_CLIB_PATH = "${pkgs.sqlite.out}/lib/libsqlite3.so";
  };
}
