# Aliases for Solarized colors; this is useful when using a Solarized
# colorscheme.

typeset -gA fg_solarized
typeset -gA bg_solarized

fg_solarized=(
  base03    '\e[90m'
  base02    $fg[black]
  base01    '\e[92m'
  base00    '\e[93m'
  base0     '\e[94m'
  base1     '\e[96m'
  base2     $fg[white]
  base3     '\e[97m'
  yellow    $fg[yellow]
  orange    '\e[91m'
  red       $fg[red]
  magenta   $fg[magenta]
  violet    '\e[95m'
  blue      $fg[blue]
  cyan      $fg[cyan]
  green     $fg[green]
)

bg_solarized=(
  base03    '\e[100m'
  base02    $bg[black]
  base01    '\e[102m'
  base00    '\e[103m'
  base0     '\e[104m'
  base1     '\e[106m'
  base2     $bg[white]
  base3     '\e[107m'
  yellow    $bg[yellow]
  orange    '\e[101m'
  red       $bg[red]
  magenta   $bg[magenta]
  violet    '\e[105m'
  blue      $bg[blue]
  cyan      $bg[cyan]
  green     $bg[green]
)
