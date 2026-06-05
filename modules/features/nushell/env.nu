# Nushell Environment Config File

# The prompt indicators are environmental variables that represent
# the state of the prompt. I set some of these to empty strings because I want
# starship to manage my prompt instead.
$env.PROMPT_INDICATOR = {|| "" }
$env.PROMPT_INDICATOR_VI_INSERT = {|| "" }
$env.PROMPT_INDICATOR_VI_NORMAL = {|| "" }
$env.PROMPT_MULTILINE_INDICATOR = {|| "::: " }

$env.EDITOR = "nvim"
$env.VISUAL = $env.EDITOR
$env.MANPAGER = "nvim +Man!"
