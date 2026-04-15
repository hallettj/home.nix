# Escape sequences for cursor shapes:
#
#     "\e[1 q" # solid block
#     "\e[2 q" # solid block
#     "\e[4 q" # underscore
#     "\e[5 q" # beam

INSERT_MODE_CURSOR='\e[5 q'
NORMAL_MODE_CURSOR='\e[1 q'

# Define behavior for a zle widget without replacing existing user-defined
# or built-in behavior. Example usage:
#
#     function reset-cursor-shape {
#       echo -ne '\e[1 q'
#     }
#
#     chain-widget zle-line-init reset-cursor-shape
#
# The example runs `reset-cursor-shape` when the `zle-line-init` widget runs,
# and also calls any previously-defined `zle-line-init` widget.
function chain-widget {
  local widget_name="$1"
  local implementation_name="$2"
  # Check for existence of a custom user func
  if [[ ${widgets[$1]} == user:* && ${widgets[$1]} != "user:$2" ]]; then
    # drop the user: prefix
    to_exec="${widgets[$1]#"user:"} \"\$@\""
  elif [[ -n ${widgets[.$1]} ]]; then
    # There is no existing user-defined widget, but there is a special reference
    # to the built-in behavior.
    to_exec="zle .$1 \"\$@\""
  else
    to_exec=""
  fi
  local chained="_chain_$1_$2"

  # Define a function that invokes the new implementation and the original.
  eval "function $chained {
    \"$2\" \"$@\"
    ${to_exec}
  }"
  zle -N "$1" "$chained"
}

# Change cursor shape for different vi modes.
function _change_cursor_shape_for_keymap {
  if [[ ${KEYMAP} == vicmd ]] ||
     [[ $1 = 'block' ]]; then
    echo -ne "$NORMAL_MODE_CURSOR"

  elif [[ ${KEYMAP} == main ]] ||
       [[ ${KEYMAP} == viins ]] ||
       [[ ${KEYMAP} = '' ]] ||
       [[ $1 = 'beam' ]]; then
    echo -ne "$INSERT_MODE_CURSOR"
  fi
}
chain-widget zle-keymap-select _change_cursor_shape_for_keymap

function _set_cursor_shape_for_insert_mode {
  echo -ne "$INSERT_MODE_CURSOR"
}
chain-widget zle-line-init _set_cursor_shape_for_insert_mode
