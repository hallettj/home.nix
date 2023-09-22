$env.config = {
  edit_mode: vi,
  show_banner: false,
}

# git aliases
alias gtop = cd (git rev-parse --show-toplevel)
alias add = git add -p
alias sw = git switch
alias ci = git commit
alias lg = git log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit
alias pull = git pull
alias push = git push
alias show = git show
alias st = git status
alias re = git restore
alias fix = git commit --fixup
alias pr = gh pr checkout

# nix aliases
alias rebuild = sudo nixos-rebuild switch --flake ~/Documents/NixConfig
alias switch = home-manager switch --flake ~/Documents/NixConfig
alias pkg = nix search nixpkgs

alias grep = grep --color=auto

def mkpass [] {
  grep -v '[^a-z]' $env.WORDLIST | shuf --random-source=/dev/urandom | head -n5 | paste -sd ' '
}

def keycode [] {
  xev | grep -A2 --line-buffered '^KeyRelease' | sed -n '/keycode /s/^.*keycode \([0-9]*\).* (.*, \(.*\)).*$/\1 \2/p'
}
