local ls = require('luasnip')
local s = ls.snippet
-- local sn = ls.snippet_node
-- local isn = ls.indent_snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
-- local c = ls.choice_node
-- local d = ls.dynamic_node
-- local r = ls.restore_node
-- local events = require('luasnip.util.events')
-- local ai = require('luasnip.nodes.absolute_indexer')
-- local fmt = require('luasnip.extras.fmt').fmt
-- local extras = require('luasnip.extras')
-- local m = extras.m
-- local l = extras.l
-- local rep = extras.rep
-- local postfix = require('luasnip.extras.postfix').postfix

-- args is a table, where 1 is the text in Placeholder 1, 2 the text in
-- placeholder 2, etc.
local function copy(args)
  return args[1]
end

ls.add_snippets('haskell', {
  s({ trig = 'HasCodec', dscr = 'instance for HasCodec' }, {
    t('instance HasCodec '), i(1, 'Type'), t(' where'),
    t({ '', '\tcodec = ' }), i(2, 'undefined'),
  })
})

ls.add_snippets('haskell', {
  s({ trig = 'obj', dscr = 'Autodocodec object codec' }, {
    t('AC.object "'), f(copy, 1), t('" $ '),
    t({ '', '\t' }), i(1, 'Type'),
    t({ '', '\t\t<$> ' }), i(0),
  })
})

ls.add_snippets('haskell', {
  s({ trig = 'objCodec', dscr = 'instance for HasCodec with object codec' }, {
    t('instance HasCodec '), i(1, 'Type'), t(' where'),
    t({ '', '\tcodec = AC.object "' }), f(copy, 1), t('" $ '),
    t({ '', '\t\t' }), f(copy, 1),
    t({ '', '\t\t\t<$> ' }), i(0),
  })
})

ls.add_snippets('haskell', {
  s({ trig = 'newtypeCodec', dsrc = 'instance for HasCodec for simple newtype' }, {
    t('instance HasCodec '), i(1, 'Type'), t(' where'),
    t({ '', '\tcodec = dimapCodec ' }), f(copy, 1), t(' '), i(2, 'unConstructor'), t(' codec'), i(0),
  })
})
