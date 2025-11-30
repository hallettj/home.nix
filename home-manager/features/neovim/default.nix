{ config, flakePath, pkgs, ... }:

let
  # Out-of-store symlinks require absolute paths when using a flake config. This
  # is because relative paths are expanded after the flake source is copied to
  # a store path which would get us read-only store paths.
  useOutOfStoreSymlinks =
    if builtins.hasAttr "useOutOfStoreSymlinks" config.home
    then config.home.useOutOfStoreSymlinks
    else false;
  dir = "${flakePath config}/home-manager/features/neovim";
in
{
  xdg.configFile.nvim = {
    source = if useOutOfStoreSymlinks then config.lib.file.mkOutOfStoreSymlink "${dir}/nvim-config" else ./nvim-config;
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    withPython3 = true;
    plugins = [
      pkgs.vimPlugins.lazy-nvim

      # Get the treesitter plugin from nix with prebuilt grammars. Lazy.nvim
      # somehow prevents the plugin from loading automatically so we also need
      # to declare the plugin to lazy.nvim. I have a helper function in my
      # neovim configuration for that called `from_nixpkgs`.
      { plugin = pkgs.vimPlugins.nvim-treesitter.withAllGrammars; type = "lua"; optional = true; }

      # Blink uses a compiled fuzzy finder. The nix plugin package links to the
      # required derivation.
      { plugin = pkgs.vimPlugins.blink-cmp; type = "lua"; optional = true; }

      # Avante needs to build a thing
      { plugin = pkgs.vimPlugins.avante-nvim; type = "lua"; optional = true; }
    ];
    extraPackages = with pkgs; [
      fd
      gh # for github integration
      ripgrep # used by obsidian.nvim, smart-open and other plugins

      # needed to compile fzf-native for telescope-fzf-native.nvim
      gcc
      gnumake

      # To allow plugins to get dependencies from luarocks
      lua51Packages.lua
      lua51Packages.luarocks
      python3

      # language servers
      basedpyright # Python LSP server
      deno
      lua-language-server
      nil # Nix LSP
      nodePackages.bash-language-server
      nodePackages.typescript-language-server
      ruff # another Python LSP server that provides formatting
      shellcheck # called by bash-language-server

      # formatters
      black # python code formatter
      isort # python import sorter

      # Rust support
      lldb # debug adapter
      graphviz # to render crate graphs from rustaceanvim

      python312Packages.pylatexenc # to get latex2text for render-markdown
      nixpkgs-fmt # I have nil configured to call this for formatting
    ];
  };

  home.packages = with pkgs; [
    # language servers
    vscode-langservers-extracted

    # Provides codelldb which rustaceanvim uses for debugging Rust targets
    vscode-extensions.vadimcn.vscode-lldb.adapter
  ];

  home.sessionVariables = {
    # Read by kkharji/sqlite.lua plugin which is a dependency of smart-open
    SQLITE_CLIB_PATH = "${pkgs.sqlite.out}/lib/libsqlite3.so";
  };
}
