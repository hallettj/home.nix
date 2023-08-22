# Options for lukechilds/zsh-nvm
export NVM_DIR="$HOME/.nvm"
export NVM_AUTO_USE=true # automatically set node version from .nvmrc files

zplug "lib/completion", from:oh-my-zsh
zplug "lib/history", from:oh-my-zsh
zplug "chrisands/zsh-yarn-completions", defer:2
zplug "lukechilds/zsh-nvm"
zplug "jeffreytse/zsh-vi-mode"
zplug "momo-lab/zsh-abbrev-alias"
zplug "zsh-users/zsh-autosuggestions", at:develop
zplug "zsh-users/zsh-history-substring-search"
zplug "zsh-users/zsh-syntax-highlighting", defer:2
zplug "andrewferrier/fzf-z", defer:1 # depends on rupa/z
zplug "rupa/z", use:z.sh

if ! zplug check --verbose; then
  printf "Install? [y/N]: "
  if read -q; then
    echo; zplug install
  fi
fi

zplug load

