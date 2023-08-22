return {
  'lewis6991/gitsigns.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'folke/which-key.nvim'
  },

  -- Lower priority to run later to avoid key binding conflicts. This is the
  -- same priority we have for which-key.
  priority = 10,

  config = function()
    local wk = require('which-key')

    require('gitsigns').setup {
      signs = { add = { text = '│' }, change = { text = '│' } },

      -- Key bindings copied directly from the gitsigns readme
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map('n', ']c', function()
          if vim.wo.diff then return ']c' end
          vim.schedule(function() gs.next_hunk() end)
          return '<Ignore>'
        end, { expr = true, desc = 'jump to next changed hunk' })

        map('n', '[c', function()
          if vim.wo.diff then return '[c' end
          vim.schedule(function() gs.prev_hunk() end)
          return '<Ignore>'
        end, { expr = true, desc = 'jump to prev changed hunk' })

        -- Actions
        wk.register({
          name = '+gitsigns',
          s = { '<cmd>Gitsigns stage_hunk<CR>', 'stage hunk' },
          S = { gs.stage_buffer, 'stage buffer' },
          r = { '<cmd>Gitsigns reset_hunk<CR>', 'reset hunk' },
          R = { gs.reset_buffer, 'reset buffer' },
          u = { gs.undo_stage_hunk, 'undo stage hunk' },
          p = { gs.preview_hunk, 'preview hunk' },
          b = { function() gs.blame_line { full = true } end, 'blame line' },
          d = { gs.diffthis, 'diffthis' },
          D = { function() gs.diffthis('~') end, 'diffthis("~")' }
        }, { prefix = '<leader>h' })

        wk.register({
          name = '+gitsigns',
          s = { '<cmd>Gitsigns stage_hunk<CR>', 'stage hunk' },
          r = { '<cmd>Gitsigns reset_hunk<CR>', 'reset hunk' }
        }, { prefix = '<leader>h', mode = 'v' })

        wk.register({
          name = '+toggles',
          b = { gs.toggle_current_line_blame, 'current line blame' },
          d = { gs.toggle_deleted, 'deleted' }
        }, { prefix = '<leader>t' })

        -- Text object
        map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>', { desc = 'select changed hunk' })
      end
    }

  end,
}
