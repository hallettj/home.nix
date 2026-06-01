; extends

; Imports
(extern_crate_declaration
  name: (identifier) @import.inner)

(extern_crate_declaration) @import.outer

(use_declaration
  argument:
    (scoped_identifier
      name: (identifier) @import.inner)) ; use std::process::Child;

(use_list) @import.inner ; use std::process::{Child, Command, Stdio};

(use_as_clause
  path:
    (scoped_identifier
      name: (_) @_start)
  alias: (_) @_end
  (#make-range! "import.inner" @_start @_end))

(use_declaration) @import.outer
