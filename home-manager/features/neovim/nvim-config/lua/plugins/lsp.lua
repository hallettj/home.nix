local features = require('config.features')

return {
  'neovim/nvim-lspconfig',
  dependencies = {
    -- Special LSP support for neovim API and for plugin APIs for plugins loaded
    -- through lazy
    'folke/neodev.nvim',
  },
  config = function()
    local lspconfig = require('lspconfig')

    -- Extending lsp capabilities is required prior to nvim v0.11. Blink at
    -- least doesn't require this step in v0.11. I'm not sure about
    -- nvim-cmp.
    local extraLspCapabilities = nil
    if features.blink then
      extraLspCapabilities = require('blink.cmp').get_lsp_capabilities()
    elseif features.nvim_cmp then
      extraLspCapabilities = require('cmp_nvim_lsp').default_capabilities()
    end
    if extraLspCapabilities then
      local lspconfig_defaults = require('lspconfig').util.default_config
      lspconfig_defaults.capabilities = vim.tbl_deep_extend(
        'force',
        lspconfig_defaults.capabilities,
        extraLspCapabilities
      )
    end

    vim.diagnostic.config {
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = '◈',
          [vim.diagnostic.severity.WARN] = '▲',
          [vim.diagnostic.severity.HINT] = '⚑',
          [vim.diagnostic.severity.INFO] = '»',
        },
      }
    }

    -- New inlay hints in nvim-0.10!
    if vim.fn.has('nvim-0.10') == 1 then
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('EnableInlayHints', { clear = true }),
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if client ~= nil and client.server_capabilities.inlayHintProvider then
            vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
          end
        end
      })
    end

    lspconfig.bashls.setup {}
    lspconfig.jsonls.setup {}
    lspconfig.nickel_ls.setup {}
    lspconfig.nushell.setup {}
    lspconfig.uiua.setup {}

    -- To set up with custom configuration, use `lspconfig` as seen below.
    -- We don't set up rust_analyzer in any of these steps because it is set up
    -- by rustaceanvim instead.

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
    local ts_ls = {
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
    lspconfig.denols.setup { autostart = true }
    lspconfig.ts_ls.setup {
      autostart = false,
      settings = {
        typescript = ts_ls,
        javascript = ts_ls,
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
