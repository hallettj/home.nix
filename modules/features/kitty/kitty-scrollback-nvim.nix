{ config, self, ... }:

{
  flake.modules.homeManager.kitty-scrollback-nvim =
    { pkgs, ... }:
    let
      # Patch kitty-scrollback-nvim to run the specialized nvim build
      kitty-scrollback-nvim =
        let
          nvim = self.packages.${pkgs.stdenv.hostPlatform.system}.neovim-for-kitty-scrollback;
          patched = pkgs.vimPlugins.kitty-scrollback-nvim.overrideAttrs (oldAttrs: {
            postPatch = ''
              substituteInPlace python/kitty_scrollback_nvim.py \
                --replace-fail "nvim_path = which('nvim')" "nvim_path = '${nvim}/bin/nvim-for-kitty-scrollback'"
            '';
          });
        in
        patched;
    in
    {
      programs.kitty = {
        extraConfig = /* kitty */ ''
          # generated with:
          # nvim --headless +'KittyScrollbackGenerateKittens' +'set nonumber' +'set norelativenumber' +'%print' +'quit!' 2>&1
          # kitty-scrollback.nvim Kitten alias
          action_alias kitty_scrollback_nvim kitten ${kitty-scrollback-nvim}/python/kitty_scrollback_nvim.py
          # Browse scrollback buffer in nvim
          map kitty_mod+h kitty_scrollback_nvim
          # Browse output of the last shell command in nvim
          map kitty_mod+g kitty_scrollback_nvim --config ksb_builtin_last_cmd_output
          # Show clicked command output in nvim
          mouse_map ctrl+shift+right press ungrabbed combine : mouse_select_command_output : kitty_scrollback_nvim --config ksb_builtin_last_visited_cmd_output
        '';
      };
    };

  # Self-contained neovim configuration specifically to be run by
  # kitty-scrollback.
  flake.wrappers.neovim-for-kitty-scrollback =
    { pkgs, wlib, ... }:
    {
      imports = with config.flake.nvim-config; [
        wlib.wrapperModules.neovim
        leap
        surround
        textobjects
        tpope
      ];

      binName = "nvim-for-kitty-scrollback";

      settings = {
        config_directory = ./nvim-config-kitty-scrollback;
        dont_link = true; # this is not the primary neovim install - don't link man pages and other stuff
      };

      # info injects data into neovim via require(vim.g.nix_info_plugin_name)(null, "nested", "attr", "path")
      info = { };

      # Lazy loading helper
      specs.lze = {
        data = pkgs.vimPlugins.lze;
        name = "lze";
      };

      specs.kitty-scrollback = {
        data = pkgs.vimPlugins.kitty-scrollback-nvim;
        config = /* lua */ ''
          require("kitty-scrollback").setup({})
        '';
      };
    };
}
