return {
  'mcchrish/zenbones.nvim',
  lazy = true,
  dependencies = { 'rktjmp/lush.nvim' },
  config = function()
    vim.g.zenbones_lightness = 'bright'
  end,
}
