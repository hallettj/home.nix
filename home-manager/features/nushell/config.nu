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
    mode: rounded
  }

  shell_integration: {
    osc2: true                                                                                                             
    osc7: true                                                                                                             
    osc8: true                                                                                                             
    osc9_9: false                                                                                                          
    osc133: true                                                                                                           
    osc633: true                                                                                                           
    reset_application_mode: true                                       
  }

  use_kitty_protocol: true

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
alias show = git show --ext-diff
alias st = git status
alias re = git restore
alias fix = git commit --fixup=commit
alias pr = gh pr checkout

# nix aliases
alias switch = nh os switch
alias pkg = nix search nixpkgs

alias grep = grep --color=auto

# Create a directory, and immediately cd into it.
# The --env flag propagates the PWD environment variable to the caller, which is
# necessary to make the directory change stick.
def --env dir [dirname: string] {
  mkdir $dirname
  cd $dirname
}

# Create a temporary directory, and cd into it.
def --env tmp [
  dirname?: string # the name of the directory - if omitted the directory is named randomly
] {
  if ($dirname != null) {
    dir $"/tmp/($dirname)"
  } else {
    cd (mktemp -d)
  }
}

def keycode [] {
  xev | grep -A2 --line-buffered '^KeyRelease' | sed -n '/keycode /s/^.*keycode \([0-9]*\).* (.*, \(.*\)).*$/\1 \2/p'
}

# Generate a random secure passphrase
def mkpass [
  word_count: int = 5
] {
  grep -v '[^a-z]' $env.WORDLIST | shuf --random-source=/dev/urandom | head -n $word_count | paste -sd ' '
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

## Docker

# List containers
def "docker ps" [
  --all (-a)            # Show all containers (default shows just running)
  --filter (-f): string # Filter output based on conditions provided (format: name=value)
  --format: string      # Pretty-print containers using a Go template
  --last (-n): int      # Show n last-created containers (includes all states) (default -1)
  --latest (-l)         # Show the latest-created container (includes all states)
  --no-trunc            # Don't truncate output
] {
  let flags = [
    (if ($all) { [--all] } else { [] })
    (if ($filter != null) { [--filter $filter] } else { [] })
    [--size --no-trunc]
  ] | flatten
  ^docker ps ...$flags
    | lines
    | skip 1  # skip column headings
    | parse -r '^(?<id>.+?)\s\s\s+(?<image>.+?)\s\s\s+(?<command>.+?)\s\s\s+(?<created>.+?)\s\s\s+(?<status>.+?)\s\s\s+(?<ports>(?:\S+/(?:tcp|udp)(?:,\s)?)*)\s\s\s+(?<names>.*?)\s\s\s+(?:(?<size>\S+) \(virtual (?<virtual>\S+)\))$'
    | update id { |it| if ($no_trunc) { $it.id } else { $it.id | str substring 0..12 } }
    | update command { |it| $it.command | str replace -r '^"(.*)"$' '$1' }  # remove quotes from command
    | update command { |it| if ($no_trunc) { $it.command } else { $it.command | str substring 0..19 } }
    | update status { |it| $it.status | parse_docker_status }
    | update ports { |it| $it.ports | split row ", " | each { |it| $it | str trim } | filter { |it| not ($it | is-empty) } }
    | update size { |it| $it.size | into filesize }
    | update virtual { |it| $it.virtual | into filesize }
}

def parse_docker_status [] {
  parse -r '^(?<state>Created|Up|Exited \((?<code>\d+)\))(?: (?<since>.*?))(?: (?<healthy>\(healthy\)))?$'
    | update state { |it| $it.state | split words | first }
    | update code { |it| if (not ($it.code | is-empty)) { $it.code | into int } else { $it.code } }
    | update healthy { |it| if (not ($it.healthy | is-empty)) { true } else { null } }
}

# List images
def "docker image list" [
  --all (-a)            # Show all images (default hides intermediate images)
  --digests             # Show digests
  --filter (-f): string # Filter output based on conditions provided
  --no-trunc            # Don't truncate output
] {
  let flags = [
    (if ($all) { [--all] } else { [] })
    (if ($digests) { [--digests] } else { [] })
    (if ($no_trunc) { [--no-trunc] } else { [] })
    [--format json]
  ] | flatten
  ^docker image list ...$flags
   | from json --objects
   | move Repository Tag ID CreatedSince Size --before Containers
}

## General commands

# Like `from json` except that it does not fail on non-string inputs. If the
# input is not a string it is passed through unchanged.
def "from maybe-json" [] {
  if ($in | describe) == string { $in | from json } else { $in }
}

## Working with Arion

# Get log output from Arion/docker-compose services with JSON parsing. If an
# argument is given filters to logs from the given service
#
# Produces a list of records (not a table unfortunately) with the fields:
# service, timestamp, level, fields, target, span, spans
def logs [
  service?: string@docker_compose_services
  --file (-f): string = "./arion-compose.nix" # Use FILE instead of the default ./arion-compose.nix
] {
  let args = [$service] | compact
  let input = if ($file | path exists) {
    arion --file $file logs ...$args
  } else {
    docker-compose logs ...$args
  }
  $input
    | lines
    | parse -r '^(?<service>\S+)\s*\|\s*(?<log>.*)$'
    | where {|it| is_json $it.log}
    | update log {|it| $it.log | from json }
    | flatten
}

# Gets log output from a given docker-compose service, and extracts and formats
# relevant opentelemetry data
def otel [
  service: string@docker_compose_services
  --file (-f): string = "./arion-compose.nix" # Use FILE instead of the default ./arion-compose.nix
] {
  logs --file $file $service
    | get resourceSpans
    | each {|it| $it.scopeSpans.0.spans.0 | select name attributes status }
}

# Helper to provide autocompletion for inputs to the logs command
def docker_compose_services [] {
  let compose_file = if ("arion-compose.nix" | path exists) {
    arion cat | from json
  } else if ("docker-compose.yaml" | path exists) {
    open docker-compose.yaml
  } else {
    return []
  }
  $compose_file | get services | columns
}

# Helper for the logs command
def is_json [input: string] {
  ($input | from json | describe) =~ '^(record|table|list)'
}

## MongoDB Agent

# Get collection schemas from mongodb agent log output.
# Builds on the logs command defined above
def schemas [] {
  logs agent |
    where fields.table_info? != null |
    get fields |
    each {|it| { validator: ($it.validator | from json), table_info: ($it.table_info | from json) } }
}

# 1Password AWS plugin integration
$env.OP_PLUGIN_ALIASES_SOURCED = 1
alias aws = op plugin run -- aws
