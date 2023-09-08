return {
  'FeiyouG/commander.nvim',
  dependencies = { 'nvim-telescope/telescope.nvim', 'folke/which-key.nvim' },
  keys = {
    {
      '<c-k>',
      function() require('commander').show() end,
      mode = 'n',
      desc = 'show commander'
    },
  },
  config = function()
    local commander = require('commander')

    commander.setup {
      integration = {
        telescope = { enable = true },
        lazy = { enable = false },
      },
    }

    -- Does the mapping begin with <Plug>?
    local is_plug = function(mapping)
      if not mapping.lhs then
        return false
      end
      local parsed_mapping = require('which-key.util').parse_keys(mapping.lhs)
      return parsed_mapping.notation[1] == '<Plug>'
    end

    -- Populate commander with key mappings that have descriptions
    for _, mapping in ipairs(vim.api.nvim_get_keymap('n')) do
      if mapping.desc and
          mapping.desc ~= 'Nvim builtin' and
          not is_plug(mapping)
      then
        commander.add { {
          desc = mapping.desc,
          cmd = mapping.callback or mapping.rhs,
          keys = { mapping.mode, mapping.lhs },
          set = false,
          show = true,
        } }
      end
    end

    -- Populate commander with user commands
    for _, command in ipairs(vim.api.nvim_get_commands({})) do
      commander.add {
        desc = command.desc,
        cmd = command.definition,
      }
    end
  end,
}
