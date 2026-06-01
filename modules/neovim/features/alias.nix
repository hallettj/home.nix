{
  flake.nvim-config.alias =
    { pkgs, ... }:
    {
      specs.alias = {
        data = pkgs.vimPlugins.vim-alias;
        config = /* lua */ ''
          -- Defer until after plugin files are sourced, since vim-alias defines
          -- the Alias command in plugin/alias.vim which loads after init.lua.
          vim.api.nvim_create_autocmd('VimEnter', {
            once = true,
            callback = function()
              vim.cmd [[Alias sw Git\ switch]]
              vim.cmd [[Alias ci Git\ commit]]
              vim.cmd [[Alias pull Git\ pull]]
              vim.cmd [[Alias push Git\ push]]
              vim.cmd [[Alias show Git\ show]]
              vim.cmd [[Alias re Git\ restore]]
              vim.cmd [[Alias lg GV]]
            end,
          })
        '';
      };
    };
}
