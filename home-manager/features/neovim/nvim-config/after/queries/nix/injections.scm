;extends

; apply lua syntax highlighting to properties named "extraLuaConfig"
(binding_set
  (binding
    attrpath: (attrpath) @_attribute
    expression: (indented_string_expression
                  (string_fragment) @injection.content))
  (#set! injection.language "lua")
  (#match? @_attribute "(^|\\.)extraLuaConfig"))
