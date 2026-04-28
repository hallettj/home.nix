{
  flake.modules.homeManager.neovide =
    {
      config,
      lib,
      pkgs,
      ...
    }:

    let
      unstableNeovim = config.programs.neovim.package == pkgs.unstable.neovim-unwrapped;
    in
    {
      programs.neovide = {
        enable = true;
        package = lib.mkIf unstableNeovim pkgs.unstable.neovide;
        settings = {
          frame = "none"; # disable the top window bar
          font = {
            normal = [ "Cartograph CF" ];
            size = lib.mkDefault 10;
          };
        };
      };

      home.packages = with pkgs; [
        wl-clipboard # used by obsidian.nvim to interact with clipboard
      ];

      home.sessionVariables = {
        # I just don't want extra UI anywhere
        NVIM_GTK_NO_HEADERBAR = "1";
      };
    };
}
