return {
  'mikesmithgh/kitty-scrollback.nvim',
  cmd = { 'KittyScrollbackGenerateKittens', 'KittyScrollbackCheckHealth' },
  event = { 'User KittyScrollbackLaunch' },
  opts = {
    -- Instead of configuring here, add configuration to
    -- lua/kitty-scrollback-config.lua
  },
}
