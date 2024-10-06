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
      -- triggers_nowait = { -- customized to remove commands that show registers
      --   -- marks
      --   '`',
      --   "'",
      --   'g`',
      --   "g'",
      --   -- spelling
      --   'z=',
      -- },
    }

    -- Swap : and ,
    map({ 'n', 'v' }, ',', ':', { desc = 'enter command mode' })
    map({ 'n', 'v' }, ':', ',', { desc = 'repeat latest f, t, F, or T in opposite direction' })

    -- Swap ' and `
    map({ 'n', 'v' }, "'", '`', { desc = 'jump to mark in the current buffer' })
    map({ 'n', 'v' }, '`', "'", { desc = 'jump to mark in the current buffer' })

    -- Window management shortcuts
    wk.add {
      { '<leader>-',   '<c-w>_',                  desc = 'maximize vertically' },
      { '<leader>=',   '<c-w>=',                  desc = 'equal window sizes' },

      { '<c-w><c-m>',  '<cmd>WinShift<cr>',       desc = 'start win-move mode' },
      { '<c-w>m',      '<cmd>WinShift<cr>',       desc = 'start win-move mode' },
      { '<c-w>X',      '<cmd>WinShift swap<cr>',  desc = 'swap two windows' },

      { '<c-left>',    '<c-w>h',                  desc = 'move to window on left' },
      { '<c-down>',    '<c-w>j',                  desc = 'move to window below' },
      { '<c-up>',      '<c-w>k',                  desc = 'move to window above' },
      { '<c-right>',   '<c-w>l',                  desc = 'move to window on right' },

      { '<c-s-left>',  '<cmd>WinShift left<cr>',  desc = 'move window left' },
      { '<c-s-down>',  '<cmd>WinShift down<cr>',  desc = 'move window down' },
      { '<c-s-up>',    '<cmd>WinShift up<cr>',    desc = 'move window up' },
      { '<c-s-right>', '<cmd>WinShift right<cr>', desc = 'move window right' },

      { '<c-h>',       '<c-w>h',                  desc = 'move to window on left' },
      { '<c-t>',       '<c-w>j',                  desc = 'move to window below' },
      { '<c-c>',       '<c-w>k',                  desc = 'move to window above' },
      { '<c-n>',       '<c-w>l',                  desc = 'move to window on right' },

      { '<c-s-h>',     '<cmd>WinShift left<cr>',  desc = 'move window left' },
      { '<c-s-t>',     '<cmd>WinShift down<cr>',  desc = 'move window down' },
      { '<c-s-c>',     '<cmd>WinShift up<cr>',    desc = 'move window up' },
      { '<c-s-n>',     '<cmd>WinShift right<cr>', desc = 'move window right' },
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
    wk.add {
      { '<leader>f', group = '+finders' },
      -- actual bindings are in plugins/telescope.lua
    }

    -- Where am I?
    map('n', '<leader>H', function() print(vim.fn.expand('%:p')) end,
      { desc = 'show file path', silent = true })

    -- IDE features
    local diagnostic = vim.diagnostic
    local telescope = function(builtin)
      return function()
        require('telescope.builtin')[builtin]()
      end
    end

    wk.add {
      { 'K', function() vim.lsp.buf.hover() end, desc = 'show documentation for symbol under cursor' },
      { 'gd', telescope 'lsp_definitions', desc = 'go to definition' },
      { 'gD', function() vim.lsp.buf.declaration() end, desc = 'go to declaration' },
      { 'go', telescope 'lsp_type_definitions', desc = 'go to type' },
      { 'gi', telescope 'lsp_implementations', desc = 'go to implementation' },
      { 'gr', telescope 'lsp_references', desc = 'find references' },
      { 'gl', diagnostic.open_float, desc = 'show diagnostic info' },
      { '[d', diagnostic.goto_prev, desc = 'previous diagnostic' },
      { ']d', diagnostic.goto_next, desc = 'next diagnostic' },
      { '[D', function() diagnostic.goto_prev({ severity = { min = diagnostic.severity.ERROR } }) end, desc = 'previous error' },
      { ']D', function() diagnostic.goto_next({ severity = { min = diagnostic.severity.ERROR } }) end, desc = 'next error' },
      { '<leader><space>', function() vim.lsp.buf.format({ async = true }) end, desc = 'format document' },
      { '<leader>u', '<cmd>MundoToggle<cr>', desc = 'toggle Mundo' },
    }

    wk.add {
      { '<leader>c', group = '+IDE' },
      { '<leader>cc', function() vim.lsp.buf.code_action() end, desc = 'code actions at cursor or selection' },
      { '<leader>cL', function() vim.lsp.codelens.run() end, desc = 'codelens command of current line' },
      { '<leader>cq', function() vim.lsp.buf.code_action({ only = { 'quickfix' } }) end, desc = 'quickfix at cursor or selection' },
      { '<leader>cr', function() vim.lsp.buf.rename() end, desc = 'rename' },
      { '<leader>cR', function() vim.lsp.buf.code_action({ only = { 'refactor' } }) end, desc = 'refactor at cursor or selection' },
      {
        mode = { 'v' },
        { '<leader>ca', function() vim.lsp.buf.code_action() end, desc = 'code actions at cursor or selection' },
        { '<leader>cq', function() vim.lsp.buf.code_action({ only = { 'quickfix' } }) end, desc = 'quickfix for cursor or selection' },
        { '<leader>cR', function() vim.lsp.buf.code_action({ only = { 'refactor' } }) end, desc = 'refactor for cursor or selection' },
      }
    }

    wk.add {
      { '<leader>"', group = "magic registers" },
      { '<leader>"d', '"=strftime("%F")<cr>', desc = 'put current date in unnamed register' },
      { '<leader>"p', '"=expand("%:p:h")<cr>', desc = 'put directory of open file in unnamed register' }
    }
  end,
}
