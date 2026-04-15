local features = require('config.features')

return {
  'windwp/nvim-autopairs',
  dependencies = {
    features.nvim_cmp and { 'hrsh7th/nvim-cmp' } or {}
  },
  event = 'InsertEnter',
  config = function()
    require('nvim-autopairs').setup {}

    -- Hook autopairs into cmp's <cr> mapping
    if features.nvim_cmp then
      local cmp_autopairs = require('nvim-autopairs.completion.cmp')
      local cmp = require('cmp')
      cmp.event:on(
        'confirm_done',
        cmp_autopairs.on_confirm_done()
      )
    end
  end,
}
