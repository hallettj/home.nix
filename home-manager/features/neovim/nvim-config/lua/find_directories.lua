-- Custom Telescope functionality to quickly cd to a directory.
local actions = require('telescope.actions')
local actions_set = require('telescope.actions.set')
local action_state = require('telescope.actions.state')
local conf = require("telescope.config").values
local finders = require('telescope.finders')
local from_entry = require('telescope.from_entry')
local previewers = require('telescope.previewers')
local pickers = require('telescope.pickers')
local sorters = require('telescope.sorters')
local utils = require('telescope.utils')

local function map(tbl, f)
    local result = {}
    for k, v in pairs(tbl) do result[k] = f(v) end
    return result
end

local exports = {}

exports.find_directories = function(opts)
    opts = opts or {}

    local search_dirs = opts.search_dirs
    local exclude = map(opts.exclude or {},
                        function(pattern) return "--exclude=" .. pattern end)
    local fd_args = {
        "--type=d", unpack(opts.fd_args or {}), unpack(exclude), ".",
        unpack(search_dirs or {})
    }

    local find_command = (function()
        if opts.find_command then
            return opts.find_command
        elseif 1 == vim.fn.executable "fd" then
            return {"fd", unpack(fd_args)}
        elseif 1 == vim.fn.executable "fdfind" then
            return {"fdfind", unpack(fd_args)}
        end
    end)()

    if not find_command then
        utils.notify("find_directories.find_directories", {
            msg = "You need to install fd or fdfind",
            level = "ERROR"
        })
        return
    end

    if opts.cwd then opts.cwd = vim.fn.expand(opts.cwd) end

    pickers.new(opts, {
        prompt_title = opts.prompt_title or "Find Directories",
        finder = finders.new_oneshot_job(find_command, opts),
        previewer = previewers.vim_buffer_cat.new(opts),
        sorter = sorters.get_fuzzy_file(),
        conf = conf.file_sorter(opts),
        attach_mappings = function(prompt_bufnr)
            actions_set.select:replace(function(_, _)
                local entry = action_state.get_selected_entry()
                actions.close(prompt_bufnr)
                local dir = from_entry.path(entry)
                local expanded_dir = vim.fn.expand((opts.cwd and (opts.cwd .. '/') or '') .. dir)
                vim.cmd('cd ' .. expanded_dir)
                print('changed directory to ' .. expanded_dir)
            end)
            return true
        end
    }):find()
end

exports.find_projects = function(opts)
    exports.find_directories {
        prompt_title = "Find Projects",
        cwd = "~",
        search_dirs = {"projects", ".config", ".homesick"},
        exclude = {".git", "node_modules"},
        fd_args = {"--max-depth=2"},
        unpack(opts or {})
    }
end

return exports
