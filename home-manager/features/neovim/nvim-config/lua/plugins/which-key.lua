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

    -- Navigation

    wk.register {
      ['<c-p>'] = { '<cmd>Telescope find_files<cr>', 'find file' },
      ['<leader>b'] = { '<cmd>Telescope buffers<cr>', 'find buffer' },
      ['<leader>O'] = { '<cmd>SymbolsOutline<cr>', 'toggle symbol outline' },
    }

    -- Telescope finders
    wk.register({
      name = '+finders',
      f = { '<cmd>Telescope find_files<cr>', 'files' },
      p = { "<cmd>lua require('find_directories').find_projects{}<cr>", 'projects' },
      g = { '<cmd>Telescope live_grep<cr>', 'live grep' },
      b = { '<cmd>Telescope buffers<cr>', 'buffers' },
      h = { '<cmd>Telescope help_tags<cr>', 'help tags' },
      c = { '<cmd>Telescope colorscheme<cr>', 'color schemes' },
      s = { '<cmd>Telescope lsp_document_symbols<cr>', 'document symbols' },
      S = { '<cmd>Telescope lsp_workspace_symbols<cr>', 'workspace symbols' },
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
    local telescope = fmt('<cmd>Telescope %s<cr>')
    local trouble = fmt('<cmd>Trouble %s<cr>')

    wk.register({
      K = { lsp 'buf.hover()', 'show documentation for symbol under cursor' },
      gd = { telescope 'lsp_definitions', 'go to definition' },
      gD = { lsp 'buf.declaration()', 'go to declaration' },
      go = { telescope 'lsp_type_definitions', 'go to type' },
      gi = { telescope 'lsp_implementations', 'go to implementation' },
      gr = { telescope 'lsp_references', 'find references' },
      gR = { trouble 'lsp_references', 'list references' },
      gl = { diagnostic.open_float, 'show diagnostic info' },
      gC = { '<cmd>RustOpenCargo<cr>', 'open Cargo.toml' },
      ['[d'] = { diagnostic.goto_prev, 'previous diagnostic' },
      [']d'] = { diagnostic.goto_next, 'next diagnostic' },
      ['[D'] = { function() diagnostic.goto_prev({ severity = { min = diagnostic.severity.ERROR } }) end,
        'previous error' },
      [']D'] = { function() diagnostic.goto_next({ severity = { min = diagnostic.severity.ERROR } }) end,
        'next error' },
      ['[x'] = { function() require('trouble').previous({ skip_groups = true, jump = true }) end,
        'previous item from Trouble' },
      [']x'] = { function() require('trouble').next({ skip_groups = true, jump = true }) end,
        'next item from Trouble' },
      ['<leader><space>'] = {
        function() vim.lsp.buf.format({ async = true }) end,
        'format document'
      },
      ['<leader>u'] = { '<cmd>MundoToggle<cr>', 'toggle Mundo' },
    })

    wk.register({
      name = '+IDE',
      c = { lsp 'buf.code_action()', 'code actions at cursor or selection' },
      l = { lsp 'codelens.run()', 'codelens command of current line' },
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

    wk.register({
      name = '+lists',
      d = { telescope 'diagnostics bufnr=0', 'diagnostics for buffer' },
      D = { telescope 'diagnostics', 'diagnostics for all buffers' },
      r = { '<cmd>RustRunnables<cr>', 'Rust runnables' },
    }, { prefix = '<leader>l' })

    wk.register({
      name = '+loclist',
      x = { trouble '', 'diagnostics (same mode as last used)' },
      w = { trouble 'workspace_diagnostics', 'workspace diagnostics ' },
      d = { trouble 'document_diagnostics', 'document diagnostics' },
      l = { trouble 'loclists', 'location list' },
      q = { trouble 'quickfix', 'quickfix list' },
      c = { '<cmd>TroubleClose<cr>', 'close Trouble' },
    }, { prefix = '<leader>x', silent = true })

    -- Debugging
    local dap = fmt('<cmd>lua require("dap").%s<cr>')
    wk.register({
      name = '+debug',
      s = {
        name = '+step',
        c = { dap 'continue()', 'Continue' },
        v = { dap 'step_over()', 'Step Over' },
        i = { dap 'step_into()', 'Step Into' },
        o = { dap 'step_out()', 'Step Out' },
      },
      h = {
        name = '+hover',
        h = { "<cmd>lua require('dap.ui.variables').hover()<CR>", 'Hover' },
        v = { "<cmd>lua require('dap.ui.variables').visual_hover()<CR>", 'Visual Hover' },
      },
      u = {
        name = '+UI',
        h = { "<cmd>lua require('dap.ui.widgets').hover()<CR>", 'Hover' },
        f = { "local widgets=require('dap.ui.widgets');widgets.centered_float(widgets.scopes)<CR>", 'Float' },
      },
      r = {
        name = '+repl',
        o = { dap 'repl.open()', 'Open' },
        l = { dap 'repl.run_last()', 'Run Last' },
      },
      b = {
        name = '+breakpoints',
        c = {
          dap 'set_breakpoint(vim.fn.input("Breakpoint condition: "))',
          'Breakpoint Condition',
        },
        m = {
          dap 'set_breakpoint({ nil, nil, vim.fn.input("Log point message: ") })',
          'Log Point Message',
        },
        t = { dap 'toggle_breakpoint()', 'Create' },
      },
      c = { dap 'scopes()', 'Scopes' },
      i = { dap 'toggle()', 'Toggle' },
    }, { prefix = '<leader>d' })

    -- tpope/vim-fugitive
    wk.register({
      name = '+git',
      s = { '<cmd>vert Git<CR>', 'git status' },
      d = { '<cmd>Gvdiffsplit<CR>', 'git diff current file' },
      D = { ':vert Git diff<space>', 'git diff prompting for refs' },
      c = { '<cmd>Git commit<CR>', 'git commit' },
      b = { '<cmd>Git blame<CR>', 'git blame' },
      l = { '<cmd>GV<cr>', 'log graph for branch' },
      L = { '<cmd>GV --all<cr>', 'log graph for all branches' },
      e = { ':Gedit<space>', 'open file from history, e.g. :Gedit HEAD^:%' },
      p = { '<cmd>Git push<CR>', 'push' },
      w = { '<cmd>Gwrite<CR>', 'write file and stage' },
      r = { ':GRename<space>', 'rename file - enter path relative to current file' },
      R = { '<cmd>GDelete<CR>', 'git rm current file and delete buffer' }
    }, { prefix = '<leader>g' })

    -- See gitsigns bindings in config/gitsigns.lua for:
    -- - <leader>h
    -- - <leader>tb, <leader>td
    -- - ]c, [c
    -- - ih

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
