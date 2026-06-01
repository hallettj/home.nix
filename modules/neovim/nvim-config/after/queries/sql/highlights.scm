;extends

; The sql queries don't apply highlighting to some nodes. When I'm using
; language injection for sql queries in strings that makes those nodes green.
; This query sets a default highlight of Normal for all nodes with priority 95,
; which is greater than the custom priority of 90 I set for Rust strings, and
; lower than the default priority for treesitter queries of 100.
((_ (#set! priority 95)) @markup.normal)
