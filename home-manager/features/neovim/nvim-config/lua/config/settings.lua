local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

local opt = vim.opt

opt.encoding = 'utf-8'
opt.scrolloff = 3
opt.wildmode = 'longest'
if vim.fn.has('ttyfast') == 1 then
  opt.ttyfast = true
end

-- Make searches case-sensitive only when capital letters are included.
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = false

-- Wrap long lines
opt.wrap = true
opt.textwidth = 80
opt.formatoptions = { c = true, q = true, r = true, n = true, ['1'] = true }

-- Reverse chirality of splits
opt.splitbelow = true
opt.splitright = true

-- When editing a file, always jump to the last cursor position
autocmd('BufReadPost', {
  group = augroup('restore-cursor-position', { clear = true }),
  pattern = '*',
  callback = function(opts)
    local last_position = vim.api.nvim_buf_get_mark(opts.buf, '"')
    local line, _ = unpack(last_position)
    local total_lines = vim.api.nvim_buf_line_count(opts.buf)
    if line ~= 0 and line <= total_lines
        and vim.bo.filetype ~= 'fugitive'
        and vim.bo.filetype ~= 'gitcommit'
        and vim.bo.filetype ~= 'gitrebase'
    then
      print(vim.bo.filetype)
      vim.api.nvim_feedkeys([[g`"]], 'nx', false)
    end
  end
})

-- Visuals --

opt.signcolumn = 'yes'
opt.showcmd = false
opt.foldenable = false

opt.listchars = { tab = '▸ ', trail = '·' }
opt.conceallevel = 0
opt.concealcursor = 'c'

-- Nicer diffs
opt.diffopt = { 'filler', 'internal', 'algorithm:histogram', 'indent-heuristic' }

autocmd('TextYankPost', {
  group = augroup('highlight-yanked-text', { clear = true }),
  callback = function()
    pcall(vim.highlight.on_yank, { higroup = 'IncSearch', timeout = 400 })
  end,
})
