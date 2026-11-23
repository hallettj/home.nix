;extends

; apply sql syntax highlighting string literal argument of sqlx::query!()
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
  (#any-of? @_macro_name "query" "query_unchecked" "query_scalar" "query_scalar_unchecked")
  (#set! injection.language "sql"))

; like the above injection, except that with sqlx::query_as!() the sql query is
; the second argument
(macro_invocation
  macro: (scoped_identifier
    path: (identifier) @_macro_path
    name: (identifier) @_macro_name)
  (token_tree
    .
    ; the output type, e.g. `Account` in sqlx::query_as!(Account, "SELECT ...")
    (_)
    .
    [
    (string_literal
      ((string_content) @injection.content))
    (raw_string_literal
      ((string_content) @injection.content))
    ])
  (#eq? @_macro_path "sqlx")
  (#any-of? @_macro_name "query_as" "query_as_unchecked")
  (#set! injection.language "sql"))
