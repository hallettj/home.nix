-- Editor support for managing Rust crates. In `Cargo.toml` you will see virtual
-- text showing the installed version for each dependency, and options for
-- upgrading.
--
-- Type `K` over a crate name, version number, or feature for an info popup.
-- Press `K` again to focus the popup. Highlight version numbers or features and
-- press `<cr>` to apply or to unapply.
--
-- To install a new dependency type it out, and when you get to the version
-- field press `<tab>` inside an empty set of quotes to see available versions.

local features = require('config.features')

return {
  'saecki/crates.nvim',
  dependencies = {
    { 'nvim-lua/plenary.nvim' },
    features.nvim_cmp and { 'hrsh7th/nvim-cmp' } or {},
  },
  config = function()
    local crates = require('crates')

    crates.setup {
      completion = {
        cmp = { enabled = features.nvim_cmp },
      },
      lsp = {
        enabled = true,
        actions = true,
        completion = true,
        hover = true,
      },
    }

    vim.api.nvim_create_autocmd('BufRead', {
      group = vim.api.nvim_create_augroup('CratesNvimCustomization', { clear = true }),
      pattern = 'Cargo.toml',
      callback = function(data)
        local wk = require('which-key')

        -- Feed version number and feature completions to cmp.
        if features.nvim_cmp then
          require('cmp').setup.buffer { sources = { { name = 'crates' } } }
        end

        -- Set up keybindings.
        wk.add {
          buffer = data.buf, silent = true,
          { '<leader>C',  group = '+crates.nvim' },
          { '<leader>Ct', crates.toggle,                  desc = 'toggle' },
          { '<leader>Cr', crates.reload,                  desc = 'reload' },
          { '<leader>Cv', crates.show_versions_popup,     desc = 'show versions' },
          { '<leader>Cf', crates.show_features_popup,     desc = 'show features' },
          { '<leader>Cd', crates.show_dependencies_popup, desc = 'show dependencies' },
          { '<leader>Cu', crates.update_crate,            desc = 'update crate' },
          { '<leader>Ca', crates.update_all_crates,       desc = 'update all crates' },
          { '<leader>CU', crates.upgrade_crate,           desc = 'upgrade crate' },
          { '<leader>CA', crates.upgrade_all_crates,      desc = 'upgrade all crates' },
          { '<leader>CH', crates.open_homepage,           desc = 'open homepage' },
          { '<leader>CR', crates.open_repository,         desc = 'open repository' },
          { '<leader>CD', crates.open_documentation,      desc = 'open documentation' },
          { '<leader>CC', crates.open_crates_io,          desc = 'open crates.io' },
          {
            mode = 'v',
            { '<leader>Cu', crates.update_crates,  desc = 'update crates' },
            { '<leader>CU', crates.upgrade_crates, desc = 'upgrade crates' },
          },
        }
        wk.add {
          buffer = data.buf, silent = true,
          { 'K', function() if (crates.popup_available()) then crates.show_popup() else vim.lsp.buf.hover() end end, desc = 'hover documentation' },
        }
      end,
    })
  end,
}
