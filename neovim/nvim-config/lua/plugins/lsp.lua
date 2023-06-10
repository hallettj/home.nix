return {
  'VonHeikemen/lsp-zero.nvim',
  branch = 'v2.x',
  dependencies = {
    -- LSP Support
    'neovim/nvim-lspconfig',
    {
      'williamboman/mason.nvim',
      build = function()
        pcall(vim.cmd, 'MasonUpdate')
      end,
    },
    'williamboman/mason-lspconfig.nvim',

    -- Autocompletion
    'hrsh7th/nvim-cmp',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'saadparwaiz1/cmp_luasnip',
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-nvim-lua',

    -- Snippets - this dependency is required according to the lsp-zero docs
    'L3MON4D3/LuaSnip',
  },
  config = function()
    local lsp = require('lsp-zero').preset {}

    lsp.set_sign_icons({
      error = '✘',
      warn = '▲',
      hint = '⚑',
      info = '»'
    })

    -- Configure lua language server for neovim
    require('lspconfig').lua_ls.setup(lsp.nvim_lua_ls())

    -- Rust analyzer is set up by rust-tools (see lua/plugins/rust-tools.lua).
    -- We want to use the system version of hls.
    lsp.skip_server_setup { 'hls', 'rust_analyzer' }

    -- We want to use the system version of hls. Lsp-zero automatically starts
    -- language servers installed by Mason, but does not automatically start other
    -- servers. This line gets configuration options from lsp-zero to provide when
    -- explicitly starting hls.
    local haskell_lsp = lsp.build_options('hls', {
      -- Disable formatting for hls - we want to be able to specify a specific
      -- version of ormolu which is easier to do with null-ls.
      on_attach = function(client)
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentRangeFormattingProvider = false
      end,
    })

    -- Configuration to make lsp-inlayhints.nvim work with TypeScript
    local tsserver_config = {
      inlayHints = {
        includeInlayParameterNameHints = 'all',
        includeInlayParameterNameHintsWhenArgumentMatchesName = false,
        includeInlayFunctionParameterTypeHints = true,
        includeInlayVariableTypeHints = true,
        includeInlayPropertyDeclarationTypeHints = true,
        includeInlayFunctionLikeReturnTypeHints = true,
        includeInlayEnumMemberValueHints = true,
      }
    }
    lsp.configure('tsserver', {
      settings = {
        typescript = tsserver_config,
        javascript = tsserver_config,
      },
    })

    -- Sets managed LSP servers running.
    lsp.setup()

    -- Language servers that are excluded from automatic startup by calling
    -- `build_options` need to be started explicitly.
    require('lspconfig').hls.setup(haskell_lsp)

    local cmp = require('cmp')
    local cmp_action = require('lsp-zero').cmp_action()

    cmp.setup {
      sources = {
        { name = 'path' },
        { name = 'nvim_lsp' },
        { name = 'buffer', keyword_length = 3 },
        { name = 'luasnip', keyword_length = 2 },
      },
      mapping = {
        -- `Enter` key to confirm completion
        ['<CR>'] = cmp.mapping.confirm({ select = false }),
        --
        -- Navigate between snippet placeholders
        ['<C-f>'] = cmp_action.luasnip_jump_forward(),
        ['<C-b>'] = cmp_action.luasnip_jump_backward(),
      },
    }

    -- Overide lsp-zero's virtual_text setting.
    vim.diagnostic.config {
      virtual_text = function()
        return {
          format = function(diagnostic)
            return diagnostic.message:gsub('^• ', ''):gsub('%s+', ' ')
          end,
        }
      end,
    }
  end,
}
