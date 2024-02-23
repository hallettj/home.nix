# Selectively disable certain plugins when running in Warp - it provides its own
# implementations for some of these.
if [[ "$TERM_PROGRAM" != "WarpTerminal" ]]; then
  zplug "lib/completion", from:oh-my-zsh
  zplug "lib/history", from:oh-my-zsh
  zplug "jeffreytse/zsh-vi-mode"
  zplug "zsh-users/zsh-autosuggestions", at:develop
  zplug "zsh-users/zsh-history-substring-search"
  zplug "zsh-users/zsh-syntax-highlighting", defer:2
fi

# These plugins are loaded regardless of terminal
zplug "momo-lab/zsh-abbrev-alias"
zplug "andrewferrier/fzf-z", defer:1 # depends on rupa/z
zplug "rupa/z", use:z.sh

if ! zplug check --verbose; then
  printf "Install? [y/N]: "
  if read -q; then
    echo; zplug install
  fi
fi

zplug load

