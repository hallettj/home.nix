return {
  'VonHeikemen/lsp-zero.nvim',
  branch = 'v3.x',
  dependencies = {
    -- Special LSP support for neovim API and for plugin APIs for plugins loaded
    -- through lazy
    'folke/neodev.nvim',
  },
  config = function()
    local lsp_zero = require('lsp-zero')

    lsp_zero.set_sign_icons({
      error = '◈',
      warn = '▲',
      hint = '⚑',
      info = '»'
    })

    -- New inlay hints in nvim-0.10!
    if vim.fn.has('nvim-0.10') == 1 then
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('EnableInlayHints', { clear = true }),
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if client ~= nil and client.server_capabilities.inlayHintProvider then
            vim.lsp.inlay_hint.enable(args.buf, true)
          end
        end
      })
    end

    local lspconfig = require('lspconfig')

    -- To set up servers without any custom configuration add them to this list.
    lsp_zero.setup_servers {
      'bashls',
      'nushell',
      'uiua',
    };

    -- To set up with custom configuration, use `lspconfig` as seen below.
    -- We don't set up rust_analyzer in any of these steps because it is set up
    -- by rust_tools instead.

    lspconfig.hls.setup {
      -- Disable formatting for hls - we want to be able to specify a specific
      -- version of ormolu which is easier to do with null-ls.
      on_attach = function(client)
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentRangeFormattingProvider = false
      end,
    }

    lspconfig.lua_ls.setup {
      settings = {
        Lua = {
          completion = {
            callSnippet = 'Replace',
          },
        },
      },
    }

    lspconfig.nil_ls.setup {
      settings = {
        ['nil'] = {
          formatting = {
            command = { 'nixpkgs-fmt' }
          }
        }
      }
    }

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

    -- The simplest way to switch between denols and tsserver is to disable
    -- autostart, and start them manually. Run `:LspStart denols` or `:LspStart
    -- tsserver`
    lspconfig.denols.setup { autostart = false }
    lspconfig.tsserver.setup {
      autostart = false,
      settings = {
        typescript = tsserver_config,
        javascript = tsserver_config,
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
