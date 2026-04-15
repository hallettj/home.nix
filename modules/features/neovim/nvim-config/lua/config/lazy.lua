-- Set <leader> to <space>. Leader and local leader must be set before
-- initializing plugins.
vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'

-- Initialize plugins, evaluating all modules in `lua/plugins/`. Lazy.nvim
-- itself is installed in the nix configuration.
require('lazy').setup {
  spec = {
    -- get plugin specs from lua/plugins/ directory
    { import = 'plugins' }
  },
  change_detection = { notify = false },
  performance = {
    -- To get treesitter grammars from nix we need to preserve the pack path
    reset_packpath = false,
    -- Resetting rtp breaks loading config from my dotfiles repo
    rtp = { reset = false },
  },
}
