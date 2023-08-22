__skim_edit_file() {
  local cmd="$1"
  local file="$(SKIM_CTRL_T_COMMAND="$cmd" __fsel)"
  local ret=$?
  zle redisplay
  typeset -f zle-line-init >/dev/null && zle zle-line-init
  if [[ -n "$file" ]]; then
    BUFFER="${EDITOR:-vim} $file"
    zle redisplay
    zle accept-line
  fi
  return $ret
}

function skim-edit-project-file() {
  __skim_edit_file "$SKIM_CTRL_T_COMMAND"
}
zle -N skim-edit-project-file
