if type op > /dev/null; then
  export OP_PLUGIN_ALIASES_SOURCED=1
  alias aws="op plugin run -- aws"
fi
