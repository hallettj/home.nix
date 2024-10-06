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
        wk.add {
          { '<leader>h', group = '+gitsigns' },
          { '<leader>hs', '<cmd>Gitsigns stage_hunk<CR>', desc = 'stage hunk' },
          { '<leader>hS', gs.stage_buffer, desc = 'stage buffer' },
          { '<leader>hr', '<cmd>Gitsigns reset_hunk<CR>', desc = 'reset hunk' },
          { '<leader>hR', gs.reset_buffer, desc = 'reset buffer' },
          { '<leader>hu', gs.undo_stage_hunk, desc = 'undo stage hunk' },
          { '<leader>hp', gs.preview_hunk, desc = 'preview hunk' },
          { '<leader>hb', function() gs.blame_line { full = true } end, desc = 'blame line' },
          { '<leader>hd', gs.diffthis, desc = 'diffthis' },
          { '<leader>hD', function() gs.diffthis('~') end, desc = 'diffthis("~")' },
          {
            mode = 'v',
            { '<leader>hs', '<cmd>Gitsigns stage_hunk<CR>', desc = 'stage hunk' },
            { '<leader>hr', '<cmd>Gitsigns reset_hunk<CR>', desc = 'reset hunk' },
          }
        }

        wk.add {
          { '<leader>t', group = '+toggles' },
          { '<leader>tb', gs.toggle_current_line_blame, desc = 'current line blame' },
          { '<leader>td', gs.toggle_deleted, desc = 'deleted' },
        }

        -- Text object
        map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>', { desc = 'select changed hunk' })
      end
    }

  end,
}
