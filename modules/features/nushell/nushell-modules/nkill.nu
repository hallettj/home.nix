# Stop a process by name - stops the entire systemd scope to clean up all related processes
def killscope [
  name: string@process-names
] {
  # let processes = ps | where name =~ $"\(?i)($name)"
  let processes = ps | where name == $name
  $processes
}

def process-names [] {
  ps | get name
}

def get-cgroup [pid: int]: any -> string {
  open $"/proc/($pid)/cgroup" | parse --regex '(?<hierarchy_id>\d+):(?<controllers>.*?):(?<path>.*)'
    | where hierarchy_id == "0" # assume cgroup v2
    | get path
    | first
}

def scope-from-cgroup-path [cgroup: string]: any -> string {
  let parsed = parse --regex '^.*(?<scope>/[^/]+\.scope)$'
  $parsed | get scope | first
}
