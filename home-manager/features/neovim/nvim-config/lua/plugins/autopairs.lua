return {
  'windwp/nvim-autopairs',
  dependencies = { 'hrsh7th/nvim-cmp' },
  event = 'InsertEnter',
  config = function()
    require('nvim-autopairs').setup {}

    -- Hook autopairs into cmp's <cr> mapping
    local cmp_autopairs = require('nvim-autopairs.completion.cmp')
    local cmp = require('cmp')
    cmp.event:on(
      'confirm_done',
      cmp_autopairs.on_confirm_done()
    )
  end,
}
