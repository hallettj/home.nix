RUSTUP_HOME=${RUSTUP_HOME:-$HOME/.rustup}
if [[ -d "$RUSTUP_HOME" ]]; then
  for f in $RUSTUP_HOME/toolchains/*/share/zsh/site-functions; do
    fpath=($f $fpath)
  done
fi
