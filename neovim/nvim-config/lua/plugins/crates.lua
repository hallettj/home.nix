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

return {
  'saecki/crates.nvim',
  event = { 'BufRead Cargo.toml' },
  dependencies = {
    { 'nvim-lua/plenary.nvim' },
    { 'hrsh7th/nvim-cmp' },
    { 'jose-elias-alvarez/null-ls.nvim' },
  },
  config = function()
    local cmp = require('cmp')
    local crates = require('crates')

    crates.setup {
      null_ls = {
        enabled = true,
        name = 'crates.nvim',
      },
    }

    vim.api.nvim_create_autocmd('BufRead', {
      group = vim.api.nvim_create_augroup('CratesNvimCustomization', { clear = true }),
      pattern = 'Cargo.toml',
      callback = function(data)
        local wk = require('which-key')

        -- Feed version number and feature completions to cmp.
        cmp.setup.buffer { sources = { { name = 'crates' } } }

        -- Set up keybindings.
        wk.register({
          name = '+crates.nvim',
          t = { crates.toggle, 'toggle' },
          r = { crates.reload, 'reload' },
          v = { crates.show_versions_popup, 'show versions' },
          f = { crates.show_features_popup, 'show features' },
          d = { crates.show_dependencies_popup, 'show dependencies' },
          u = { crates.update_crate, 'update crate' },
          a = { crates.update_all_crates, 'update all crates' },
          U = { crates.upgrade_crate, 'upgrade crate' },
          A = { crates.upgrade_all_crates, 'upgrade all crates' },
          H = { crates.open_homepage, 'open homepage' },
          R = { crates.open_repository, 'open repository' },
          D = { crates.open_documentation, 'open documentation' },
          C = { crates.open_crates_io, 'open crates.io' },
        }, { prefix = '<leader>C', buffer = data.buf, silent = true })
        wk.register({
          name = '+crates.nvim',
          u = { crates.update_crates, 'update crates' },
          U = { crates.upgrade_crates, 'upgrade crates' },
        }, { prefix = '<leader>C', mode = 'v', buffer = data.buf, silent = true })
        wk.register({
          K = { function()
            if (crates.popup_available()) then
              crates.show_popup()
            else
              vim.lsp.buf.hover()
            end
          end, 'hover documentation' },
        }, { buffer = data.buf, silent = true })
      end,
    })
  end,
}
