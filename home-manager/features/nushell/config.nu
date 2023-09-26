$env.config = {
  edit_mode: vi
  show_banner: false

  completions: {
    algorithm: fuzzy
  }

  cursor_shape: {
    vi_insert: line
    vi_normal: block
  }

  keybindings: [
    {
      name: cd_with_fuzzy_search
      modifier: control
      keycode: char_g
      mode: vi_insert
      event: {
        send: executehostcommand
        cmd: zi # installed by the programs.zoxide home manager module
      }
    }
  ]

  table: {
    mode: light
  }

  shell_integration: true

  hooks: {
    # The atuin home manager module has a bug where it assumes that these hook
    # lists already exist.
    pre_execution: []
    pre_prompt: []
  }
}

# git aliases
alias gtop = cd (git rev-parse --show-toplevel)
alias add = git add -p
alias sw = git switch
alias ci = git commit
alias lg = git log --color --graph '--pretty=format:%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit
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

def keycode [] {
  xev | grep -A2 --line-buffered '^KeyRelease' | sed -n '/keycode /s/^.*keycode \([0-9]*\).* (.*, \(.*\)).*$/\1 \2/p'
}

def mkpass [] {
  grep -v '[^a-z]' $env.WORDLIST | shuf --random-source=/dev/urandom | head -n5 | paste -sd ' '
}

# Kill processes whose names contain the given pattern. This is basically
# `killall -r`, but done the nushell way. It's handy on NixOS where process
# names are often store paths so that it's not practical to type out the entire
# process name.
#
# Returns a list of processes that were killed.
def nkill [name_pattern: string@process_names] {
  ps | where name =~ $name_pattern | each { |p| kill $p.pid; $p }
}

# Show running processes with a name matching the given pattern
def pg [name_pattern: string@process_names] {
  ps | where name =~ $name_pattern
}

def process_names [] {
  ps | get name
}
