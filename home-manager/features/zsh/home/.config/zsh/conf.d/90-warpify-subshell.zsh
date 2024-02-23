# Sets up zsh subshells to work correctly in Warp Terminal

if [[ "$TERM_PROGRAM" == "WarpTerminal" ]]; then
  printf '\eP$f{"hook": "SourcedRcFileForWarp", "value": { "shell": "zsh" }}\x9c'
fi
