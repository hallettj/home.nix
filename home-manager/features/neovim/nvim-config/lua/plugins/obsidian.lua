local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

local workspaces = {
  { name = 'Personal', path = '~/Documents/Personal' },
  { name = 'Hasura',   path = '~/Documents/Hasura' },
}

return {
  'epwalsh/obsidian.nvim',
  dependencies = {
    -- required
    'nvim-lua/plenary.nvim',

    -- optional
    'hrsh7th/nvim-cmp',
    'nvim-telescope/telescope.nvim',
  },
  lazy = false,
  keys = {
    { '<leader>fn', vim.cmd.ObsidianQuickSwitch, desc = 'open an Obsidian note' },
  },
  config = function()
    require('obsidian').setup {
      workspaces = workspaces,

      disable_frontmatter = true,

      daily_notes = {
        folder = 'Periodic',
        date_format = '%Y-%m-%d %a',
      },

      new_notes_location = 'Inbox',

      attachments = {
        img_folder = 'Attachments',
      },

      prepend_note_id = false,
    }

    local is_file_in_directory = function(file_path, directory_path)
      local file = vim.fn.fnamemodify(file_path, ':p')
      local dir = vim.fn.fnamemodify(directory_path, ':p')
      return file ~= nil and dir ~= nil and
          -- is dir an initial substring of file?
          file:find(dir, 1, true) == 1
    end

    -- If the current directory is inside a workspace, set that as the active
    -- workspace. Otherwise default to the first workspace in `workspaces`.
    local update_workspace = function(cwd)
      local matched_workspace = workspaces[1]

      for _, workspace in ipairs(workspaces) do
        if is_file_in_directory(cwd, workspace.path) then
          matched_workspace = workspace
        end
      end

      vim.cmd.ObsidianWorkspace {
        args = { matched_workspace.name },
        mods = { silent = true },
      }
    end

    local group = augroup('match-obsidian-vault-to-cwd', { clear = true })

    -- Switch selected workspace on working-directory changes
    autocmd('DirChanged', {
      group = group,
      pattern = '*',
      callback = function(event)
        update_workspace(event.file)
      end,
    })

    -- If the editor was started in a workspace directory, switch to that
    -- workspace immediately.
    update_workspace(vim.fn.getcwd())

    local is_file_in_a_workspace = function(file_path)
      for _, workspace in ipairs(workspaces) do
        if is_file_in_directory(file_path, workspace.path) then
          return true
        end
      end
      return false
    end

    -- The plugin wants conceallevel to be set to 1 or 2. I only want to apply
    -- this to files in Obsidian workspaces.
    autocmd('FileType', {
      group = group,
      pattern = 'markdown',
      callback = function(event)
        if is_file_in_a_workspace(event.file) then
          vim.opt_local.conceallevel = 1
        end
      end,
    })
  end,
}
