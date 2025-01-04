;extends

; apply sql syntax highlighting string literal argument of sqlx::query()
(call_expression
  function: (scoped_identifier
              path: (identifier) @_path
              name: (identifier) @_name)
  arguments: (arguments (string_literal ((string_content) @injection.content)))
  (#eq? @_path "sqlx")
  (#eq? @_name "query")
  (#set! injection.language "sql")
  (#set! injection.combined))

