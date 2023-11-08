-- nvim-dap is a debugging protocol to connect nvim to various debuggers
return {
  { 'mfussenegger/nvim-dap' },
  {
    'theHamsta/nvim-dap-virtual-text',
    dependencies = {
      'mfussenegger/nvim-dap',
      'nvim-treesitter/nvim-treesitter',
    },
    opts = {},
  }
}
