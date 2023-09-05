local ls = require('luasnip')
local s = ls.snippet
local t = ls.text_node

ls.add_snippets('nix', {
  s({ trig = 'stable', dscr = 'flake input for stable nixpkgs' }, {
    t('nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";')
  }),

  s({ trig = 'unstable', dscr = 'flake input for stable nixpkgs' }, {
    t('nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";')
  })
})
