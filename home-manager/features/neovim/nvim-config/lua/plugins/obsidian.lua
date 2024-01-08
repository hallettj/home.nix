local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup
local command = vim.api.nvim_create_user_command

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

      -- This config applies to `ObsidianNew`, but currently not to
      -- `ObsidianLinkNew`
      new_notes_location = 'notes_subdir',
      notes_subdir = 'Inbox',

      attachments = {
        img_folder = 'Attachments',
      },

      prepend_note_id = false,

      -- I just want to use titles as file names
      note_id_func = function(title) return title end,
    }

    -- Custom commands

    -- Create an alias of another command with an added description
    local alias = function(short_name, name, desc)
      local cmd = vim.api.nvim_get_commands({})[name]
      local def = function(data) vim.cmd { cmd = name, args = data.fargs } end
      local nargs = tonumber(cmd.nargs)
      command(short_name, def, {
        bang = cmd.bang,
        desc = desc,
        nargs = nargs ~= nil and nargs or cmd.nargs,
        range = cmd.range ~= nil and true or nil,
      })
    end

    alias('Backlinks', 'ObsidianBacklinks', 'show backlinks to the open note')
    alias('Today', 'ObsidianToday', "open today's daily note")

    local obsidian_completer = function(callback)
      local client = require('obsidian').get_client()
      return function(arg_lead, cmd_line, cursor_pos)
        local cmd_line_without_command, _ = string.gsub(cmd_line, '^%S+ ', '')
        return callback(client, arg_lead, cmd_line_without_command, cursor_pos)
      end
    end

    -- My version of `LinkNew` avoids a redundant [[title|tite]] if possible,
    -- and combines the functionality of `ObsidianLink` and `ObsidianLinkNew`
    command('Link', function(data)
      local log = require 'obsidian.log'
      local client = require('obsidian').get_client()
      local _, csrow, cscol, _ = unpack(vim.fn.getpos "'<")
      local _, cerow, cecol, _ = unpack(vim.fn.getpos "'>")

      if data.line1 ~= csrow or data.line2 ~= cerow then
        log.err 'Link must be called with visual selection'
        return
      end

      local lines = vim.fn.getline(csrow, cerow)
      if #lines ~= 1 then
        log.err 'Only in-line visual selections allowed'
        return
      end

      local line = lines[1]
      if line == nil then return end

      local link_text = string.sub(line, cscol, cecol)
      local title
      if string.len(data.args) > 0 then
        title = data.args
      else
        title = link_text
      end
      local note = client:resolve_note(title)
      local note_id = note ~= nil and tostring(note.id) or title

      local updated_line
      if note_id ~= link_text then
        updated_line = string.sub(line, 1, cscol - 1)
            .. '[['
            .. note_id
            .. '|'
            .. link_text
            .. ']]'
            .. string.sub(line, cecol + 1)
      else
        updated_line = string.sub(line, 1, cscol - 1)
            .. '[['
            .. link_text
            .. ']]'
            .. string.sub(line, cecol + 1)
      end
      vim.api.nvim_buf_set_lines(0, csrow - 1, csrow, false, { updated_line })
    end, {
      complete = obsidian_completer(require('obsidian.commands').complete_args_search),
      desc = 'turn visual selection into a link to a new or existing note',
      nargs = '?',
      range = true,
    })

    command('Note', function(opts)
      local client = require('obsidian').get_client()
      local note = client:resolve_note(opts.args)
      if note ~= nil then
        vim.cmd.edit(note.path.filename)
      else
        local new_note_path = opts.args
        local workspace_path = client.current_workspace.path
        local file_path = workspace_path .. '/Inbox/' .. new_note_path .. '.md'
        vim.cmd.edit(file_path)
      end
    end, {
      complete = obsidian_completer(require('obsidian.commands').complete_args_search),
      desc = 'open an Obsidian note, or create a new one with the given name',
      nargs = 1,
    })

    -- Sync active workspace to working directory

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

    -- Enable conceallevel conditionally

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
