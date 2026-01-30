return {
  'neovim/nvim-lspconfig',
  config = function()
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

    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('EnableInlayHints', { clear = true }),
      callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client ~= nil and client.server_capabilities.inlayHintProvider then
          vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
        end
      end
    })

    -- Custom LSP configurations are in the lsp/ directory in the root of the neovim
    -- config. Some of these use stock configurations bundled with
    -- nvim-lspconfig. To see those configs run `:h lspconfig-all`
    vim.lsp.enable {
      'bashls',
      'jsonls',
      'lua_ls',
      'nil_ls', -- Nix
      'nushell',
      'uiua',
      'yamlls',

      -- Python
      'basedpyright', -- Python type checker
      'ruff',         -- Python linter & formatter

      -- Javascript / Typescript
      -- 'denols',
      'ts_ls',
    }

    -- The Rust LSP is not listed because it is configured by rustaceanvim

    -- basedpyright configuration customization has to be here because we read
    -- from the stock configuration - putting this in the lsp/ directory leads
    -- to an infinite loop
    local original_basedpyright_on_attach = vim.lsp.config.basedpyright.on_attach
    vim.lsp.config.basedpyright = {
      on_attach = function(client, bufnr)
        if original_basedpyright_on_attach then
          original_basedpyright_on_attach(client, bufnr)
        end

        local buffer_dir = vim.fn.expand('%:p:h')
        local home_dir = vim.fn.expand('~')

        local repo_root = vim.fs.find(
          { '.git' },
          { path = buffer_dir, upward = true, stop = home_dir, limit = 1 }
        )[1]
        local stop_dir
        if repo_root == nil then
          stop_dir = home_dir
        else
          stop_dir = repo_root
        end

        local venv = vim.fs.find({ '.venv' }, { path = buffer_dir, upward = true, stop = stop_dir, limit = 1 })[1]

        if venv ~= nil then
          local python_path = vim.fs.joinpath(venv, 'bin/python')
          if vim.fn.filereadable(python_path) ~= 0 then
            client.config.settings.python = vim.tbl_deep_extend('force',
              client.config.settings.python or {},
              { pythonPath = python_path }
            )
            client.notify('workspace/didChangeConfiguration', { settings = { python = client.config.settings.python } })
          end
        end
      end,
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
