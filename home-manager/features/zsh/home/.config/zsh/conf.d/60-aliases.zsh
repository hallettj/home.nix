# The `abbrev-alias` command comes from the momo-lab/zsh-abbrev-alias plugin

alias ls="ls --color"
alias ack="ack-grep"
alias bell="echo '\a'"
alias beep=bell
alias pg="pgrep -fa"

# Alias ls to eza if it's installed
if (( $+commands[eza] )); then
	alias ls="eza"
fi

# Changes to top-level directory of git repository.
alias gtop="cd \$(git rev-parse --show-toplevel)"

# NetworkManager shortcuts
abbrev-alias -c nm="nmcli nm"
abbrev-alias -c con="nmcli con"
abbrev-alias -c wifi="nmcli device wifi"

# Generate a password
alias mkpass="grep -v '[^a-z]' /usr/share/dict/words | shuf --random-source=/dev/urandom | head -n5 | paste -sd ' '"

# Sends stdin to system clipboard
alias clip="xclip -i -selection clipboard"

alias keycode="xev | grep -A2 --line-buffered '^KeyRelease' | sed -n '/keycode /s/^.*keycode \([0-9]*\).* (.*, \(.*\)).*$/\1 \2/p'"

# tmux
abbrev-alias -c tl="tmux list-sessions"
abbrev-alias -c ts="tmux -u new-session -A -s"
abbrev-alias -c ta="tmux attach-session -t"
abbrev-alias -c tad="tmux attach-session -d -t"

# docker and docker-compose
abbrev-alias -c up='docker-compose up'
abbrev-alias -c upd='docker-compose up -d'
abbrev-alias -c stop='docker-compose stop'
abbrev-alias -c res='docker-compose restart'
abbrev-alias -c clean='docker-compose rm'
abbrev-alias -c ds='docker-compose ps'

# Nix
abbrev-alias -c rebuild="sudo nixos-rebuild switch --flake ~/Documents/NixConfig#$HOST"
abbrev-alias -c switch="home-manager switch --flake ~/Documents/NixConfig#$USER@$HOST"
abbrev-alias -c pkg='nix search nixpkgs'
