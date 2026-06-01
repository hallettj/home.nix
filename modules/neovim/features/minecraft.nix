{ inputs, ... }:
{
  flake-file.inputs.vim-mcfunction = {
    url = "github:RubixTheSlime/vim-mcfunction/f8ad1bfccb97f8f8e7ee0c52024eac3a8e491a85";
    flake = false;
  };

  flake.nvim-config.minecraft =
    { config, pkgs, ... }:
    {
      specs.minecraft.data = config.nvim-lib.mkPlugin "vim-mcfunction" inputs.vim-mcfunction;
    };
}
