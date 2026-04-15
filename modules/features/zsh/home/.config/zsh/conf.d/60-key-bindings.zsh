# Reduces delay switching between insert and command mode to 100 ms.
export KEYTIMEOUT=1

# backspace and ^h working even after
# returning from command mode
# bindkey '^?' backward-delete-char
# bindkey '^h' backward-delete-char

# ctrl-w removed word backwards
bindkey '^w' backward-kill-word

if whence -w zvm_bindkey > /dev/null; then
  # zsh-users/zsh-autosuggestions
  zvm_bindkey viins '^ ' autosuggest-accept
  zvm_bindkey viins '^_' autosuggest-clear

  # zvm_bindkey comes from jeffreytse/zsh-vi-mode - bindings added with the native
  # `bindkey` that conflict with bindings from the zsh-vi-mode plugin will be
  # overwritten by the plugin. But using `zvm_bindkey` preserves the custom
  # binding.

  # skim
  zvm_bindkey viins '^p' skim-edit-project-file

  # zsh-users/zsh-history-substring-search
  zvm_bindkey vicmd 'k' history-substring-search-up
  zvm_bindkey vicmd 'j' history-substring-search-down
fi

# expand history references and abbreviations on space or enter using the
# abbrev-alias plugin

# from: https://gist.github.com/Frost/6ee5308103c43638ed7af493c8df702d
function expand-alias-and-accept-line() {
  __abbrev_alias::magic_abbrev_expand
  zle .accept-line
}
zle -N accept-line expand-alias-and-accept-line
