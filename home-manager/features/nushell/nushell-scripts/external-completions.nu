let fish_completer = {|spans|
  fish --command $"complete '--do-complete=($spans | str replace --all "'" "\\'" | str join ' ')'"
  | from tsv --flexible --noheaders --no-infer
  | rename value display
  | update value {|row|
    let value = $row.value
    let need_quote = ['\' ',' '[' ']' '(' ')' ' ' '\t' "'" '"' "`"] | any {$in in $value}
    if ($need_quote and ($value | path exists)) {
      let expanded_path = if ($value starts-with ~) {$value | path expand --no-symlink} else {$value}
      $'"($expanded_path | str replace --all "\"" "\\\"")"'
    } else {$value}
  }
}

let carapace_completer = {|spans: list<string>|
  let completions = carapace $spans.0 nushell ...$spans
  | from json
  | if ($in | default [] | where value =~ '^-.*ERR$' | is-empty) { $in } else { null }

  # Carapace does not fall back to file path completions as a default, which is
  # very annoying. Returning null falls back to native nushell completions.
  if ($completions | is-empty) {
    null
  } else {
    $completions
  }
}

# This completer will use carapace by default
let external_completer = {|spans|
  let expanded_alias = (scope aliases | where name == $spans.0 | get -i 0 | get -i expansion)

  let spans = if $expanded_alias != null {
    $spans | skip 1 | prepend ($expanded_alias | split row ' ' | take 1)
  } else {
    $spans
  }

  match $spans.0 {
    # carapace completions are incorrect for nu
    nu => $fish_completer
    # fish completes commits and branch names in a nicer way
    git => $fish_completer
    # carapace doesn't have completions for asdf
    asdf => $fish_completer
    _ => $carapace_completer
  } | do $in $spans
}

$env.config.completions.external.completer = $external_completer
