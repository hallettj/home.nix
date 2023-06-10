if [[ -d "$HOME/.homesick/repos/homeshick" ]]; then
  source "$HOME/.homesick/repos/homeshick/homeshick.sh"
  fpath=($HOME/.homesick/repos/homeshick/completions $fpath)
fi
