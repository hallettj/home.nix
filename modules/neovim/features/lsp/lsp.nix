{
  flake.nvim-config.lsp =
    { pkgs, ... }:
    {
      specs.lspconfig = {
        data = pkgs.unstable.vimPlugins.nvim-lspconfig; # using unstable to get tsc config
        config = builtins.readFile ./lsp.lua;
      };

      runtimePkgs = with pkgs; [
        basedpyright # Python LSP server
        # deno
        lua-language-server
        nil # Nix LSP
        bash-language-server
        ruff # another Python LSP server that provides formatting
        shellcheck # called by bash-language-server
        vscode-langservers-extracted # html/css/json/eslint lsp servers extracted from vscode
        yaml-language-server
      ];
    };
}
