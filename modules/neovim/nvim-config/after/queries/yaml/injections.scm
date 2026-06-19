;extends

; bash highlighting for tasks in sourcehut .builds.yml manifest, dictionary entries
(block_mapping_pair
  key: (flow_node) @_run
  (#eq? @_run "tasks")
  value: (block_node
    (block_sequence
      (block_sequence_item
        (block_node
          (block_mapping
            (block_mapping_pair
              value: (block_node
                (block_scalar) @injection.content
                (#set! injection.language "bash")
                (#offset! @injection.content 0 1 0 0)))))))))

; bash highlighting for tasks in sourcehut .builds.yml manifest, plain string block entries 
(block_mapping_pair
  key: (flow_node) @_run
  (#eq? @_run "tasks")
  value: (block_node
    (block_sequence
      (block_sequence_item
        (block_node
          (block_scalar) @injection.content
          (#set! injection.language "bash")
          (#offset! @injection.content 0 1 0 0))))))

; bash highlighting for tasks in sourcehut .builds.yml manifest, plain string non-block entries 
(block_mapping_pair
  key: (flow_node) @_run
  (#eq? @_run "tasks")
  value: (block_node
    (block_sequence
      (block_sequence_item
        (flow_node
          [(single_quote_scalar) (double_quote_scalar)] @injection.content
          (#set! injection.language "bash")
          (#offset! @injection.content 0 1 0 -1))))))
