return {
  'folke/which-key.nvim',

  -- I'm getting non-deterministic key binding conflicts, so I'm setting this
  -- spec to a low priority so that it runs after other plugin configs. (Default
  -- is 50.)
  priority = 10,

  config = function()
    local wk = require('which-key')
    local map = vim.keymap.set

    wk.setup {
      triggers_nowait = { -- customized to remove commands that show registers
        -- marks
        '`',
        "'",
        'g`',
        "g'",
        -- spelling
        'z=',
      },
    }

    -- Swap : and ,
    map({ 'n', 'v' }, ',', ':', { desc = 'enter command mode' })
    map({ 'n', 'v' }, ':', ',', { desc = 'repeat latest f, t, F, or T in opposite direction' })

    -- Swap ' and `
    map({ 'n', 'v' }, "'", '`', { desc = 'jump to mark in the current buffer' })
    map({ 'n', 'v' }, '`', "'", { desc = 'jump to mark in the current buffer' })

    -- Window management shortcuts
    wk.register {
      ['<leader>-'] = { '<c-w>_', 'maximize vertically' },
      ['<leader>='] = { '<c-w>=', 'equal window sizes' },

      ['<c-w><c-m>'] = { '<cmd>WinShift<cr>', 'start win-move mode' },
      ['<c-w>m'] = { '<cmd>WinShift<cr>', 'start win-move mode' },
      ['<c-w>X'] = { '<cmd>WinShift swap<cr>', 'swap two windows' },

      ['<c-left>'] = { '<c-w>h', 'move to window on left' },
      ['<c-down>'] = { '<c-w>j', 'move to window below' },
      ['<c-up>'] = { '<c-w>k', 'move to window above' },
      ['<c-right>'] = { '<c-w>l', 'move to window on right' },

      ['<c-s-left>'] = { '<cmd>WinShift left<cr>', 'move window left' },
      ['<c-s-down>'] = { '<cmd>WinShift down<cr>', 'move window down' },
      ['<c-s-up>'] = { '<cmd>WinShift up<cr>', 'move window up' },
      ['<c-s-right>'] = { '<cmd>WinShift right<cr>', 'move window right' },

      ['<c-h>'] = { '<c-w>h', 'move to window on left' },
      ['<c-t>'] = { '<c-w>j', 'move to window below' },
      ['<c-c>'] = { '<c-w>k', 'move to window above' },
      ['<c-n>'] = { '<c-w>l', 'move to window on right' },

      ['<c-s-h>'] = { '<cmd>WinShift left<cr>', 'move window left' },
      ['<c-s-t>'] = { '<cmd>WinShift down<cr>', 'move window down' },
      ['<c-s-c>'] = { '<cmd>WinShift up<cr>', 'move window up' },
      ['<c-s-n>'] = { '<cmd>WinShift right<cr>', 'move window right' },
    }

    -- Retain selection in visual mode when indenting blocks
    map('v', '<', '<gv', { desc = "shift selection leftwards one 'shiftwidth'" })
    map('v', '>', '>gv', { desc = "shift selection rightwards one 'shiftwidth'" })

    -- System copy/paste shortcuts
    -- These come from:
    -- http://sheerun.net/2014/03/21/how-to-boost-your-vim-productivity/
    for _, mode in ipairs { 'n', 'v' } do
      map(mode, '<leader>y', '"+y', { desc = 'yank to system clipboard' })
      map(mode, '<leader>p', '"+p', { desc = 'paste from system clipboard after cursor' })
      map(mode, '<leader>P', '"+P', { desc = 'paste from system clipboard before cursor' })
    end

    -- Telescope finders
    wk.register({
      name = '+finders',
      -- actual bindings are in plugins/telescope.lua
    }, { prefix = '<leader>f' })

    -- Where am I?
    wk.register({
      ['<leader>H'] = {
        function() print(vim.fn.expand('%:p')) end, 'show file path'
      }
    }, { silent = true })

    -- IDE features
    local fmt = function(cmd) return function(str) return cmd:format(str) end end
    local lsp = fmt('<cmd>lua vim.lsp.%s<cr>')
    local diagnostic = vim.diagnostic
    local telescope = function(builtin)
      return function()
        require('telescope.builtin')[builtin]()
      end
    end

    wk.register({
      K = { lsp 'buf.hover()', 'show documentation for symbol under cursor' },
      gd = { telescope 'lsp_definitions', 'go to definition' },
      gD = { lsp 'buf.declaration()', 'go to declaration' },
      go = { telescope 'lsp_type_definitions', 'go to type' },
      gi = { telescope 'lsp_implementations', 'go to implementation' },
      gr = { telescope 'lsp_references', 'find references' },
      gl = { diagnostic.open_float, 'show diagnostic info' },
      ['[d'] = { diagnostic.goto_prev, 'previous diagnostic' },
      [']d'] = { diagnostic.goto_next, 'next diagnostic' },
      ['[D'] = { function() diagnostic.goto_prev({ severity = { min = diagnostic.severity.ERROR } }) end,
        'previous error' },
      [']D'] = { function() diagnostic.goto_next({ severity = { min = diagnostic.severity.ERROR } }) end,
        'next error' },
      ['<leader><space>'] = {
        function() vim.lsp.buf.format({ async = true }) end,
        'format document'
      },
      ['<leader>u'] = { '<cmd>MundoToggle<cr>', 'toggle Mundo' },
    })

    wk.register({
      name = '+IDE',
      c = { lsp 'buf.code_action()', 'code actions at cursor or selection' },
      L = { lsp 'codelens.run()', 'codelens command of current line' },
      q = { lsp 'buf.code_action({ only = {"quickfix"} })', 'quickfix at cursor or selection' },
      r = { lsp 'buf.rename()', 'rename' },
      R = { lsp 'buf.code_action({ only = {"refactor"} })', 'refactor at cursor or selection' },
    }, { prefix = '<leader>c', remap = true })
    wk.register({
      name = '+IDE',
      a = { lsp 'buf.code_action()', 'code actions at cursor or selection' },
      q = { lsp 'buf.code_action({ only = {"quickfix"} })', 'quickfix for cursor or selection' },
      R = { lsp 'buf.code_action({ only = {"refactor"} })', 'refactor for cursor or selection' },
    }, { prefix = '<leader>c', mode = 'v' })

    -- gh.nvim bindings
    wk.register({
      name = '+Github',
      c = {
        name = '+Commits',
        c = { '<cmd>GHCloseCommit<cr>', 'Close' },
        e = { '<cmd>GHExpandCommit<cr>', 'Expand' },
        o = { '<cmd>GHOpenToCommit<cr>', 'Open To' },
        p = { '<cmd>GHPopOutCommit<cr>', 'Pop Out' },
        z = { '<cmd>GHCollapseCommit<cr>', 'Collapse' }
      },
      i = { name = '+Issues', p = { '<cmd>GHPreviewIssue<cr>', 'Preview' } },
      l = { name = '+Litee', t = { '<cmd>LTPanel<cr>', 'Toggle Panel' } },
      r = {
        name = '+Review',
        b = { '<cmd>GHStartReview<cr>', 'Begin' },
        c = { '<cmd>GHCloseReview<cr>', 'Close' },
        d = { '<cmd>GHDeleteReview<cr>', 'Delete' },
        e = { '<cmd>GHExpandReview<cr>', 'Expand' },
        s = { '<cmd>GHSubmitReview<cr>', 'Submit' },
        z = { '<cmd>GHCollapseReview<cr>', 'Collapse' }
      },
      p = {
        name = '+Pull Request',
        c = { '<cmd>GHClosePR<cr>', 'Close' },
        d = { '<cmd>GHPRDetails<cr>', 'Details' },
        e = { '<cmd>GHExpandPR<cr>', 'Expand' },
        o = { '<cmd>GHOpenPR<cr>', 'Open' },
        p = { '<cmd>GHPopOutPR<cr>', 'PopOut' },
        r = { '<cmd>GHRefreshPR<cr>', 'Refresh' },
        t = { '<cmd>GHOpenToPR<cr>', 'Open To' },
        z = { '<cmd>GHCollapsePR<cr>', 'Collapse' }
      },
      t = {
        name = '+Threads',
        c = { '<cmd>GHCreateThread<cr>', 'Create' },
        n = { '<cmd>GHNextThread<cr>', 'Next' },
        t = { '<cmd>GHToggleThread<cr>', 'Toggle' }
      }
    }, { prefix = '<leader>gh' })

    -- Magic Registers
    wk.register({
      d = { '"=strftime("%F")<cr>', 'put current date in unnamed register' },
      p = {
        '"=expand("%:p:h")<cr>',
        'put directory of open file in unnamed register'
      }
    }, { prefix = '<leader>"' })
  end,
}
