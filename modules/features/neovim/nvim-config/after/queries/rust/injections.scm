;extends

; apply sql syntax highlighting string literal argument of sqlx::query()
(macro_invocation
  macro: (scoped_identifier
    path: (identifier) @_macro_path
    name: (identifier) @_macro_name)
  (token_tree
    .
    [
    (string_literal
      ((string_content) @injection.content))
    (raw_string_literal
      ((string_content) @injection.content))
    ])
  (#eq? @_macro_path "sqlx")
  (#match? @_macro_name "query(_as|_scalar|)")
  (#set! injection.language "sql"))
