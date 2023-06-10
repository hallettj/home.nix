-- automatically closes delimiters as they are typed
return {
  'kana/vim-smartinput',
  config = function()
    -- Do not automatically close single quotes in Rust when writing lifetime
    -- variable declarations.
    vim.cmd([[
      call smartinput#define_rule({
      \   'at': '<\s*\(''\s*[a-z]\s*,\s*\)*\%#',
      \   'char': '''',
      \   'input': '''',
      \   'filetype': ['rust'],
      \ })
    ]])

    -- Do not automatically close single quotes in Rust when writing reference types
    -- with lifetime specifiers.
    vim.cmd([[
      call smartinput#define_rule({
      \   'at': '&\%#',
      \   'char': '''',
      \   'input': '''',
      \   'filetype': ['rust'],
      \ })
    ]])
  end,
}
