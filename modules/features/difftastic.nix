{
  # Wrap difftastic to automatically switch display modes depending on terminal
  # width unless a specific mode is set.
  nixpkgs.overlays = [
    (final: prev: {
      difftastic = final.writeShellApplication {
        name = "difft";
        text = ''
          width=""
          display_set=false
          args=()
          while [[ $# -gt 0 ]]; do
            case "$1" in
              --width)
                width="$2"
                args+=("$1" "$2")
                shift 2
                ;;
              --width=*)
                width="''${1#--width=}"
                args+=("$1")
                shift
                ;;
              --display | --display=*)
                display_set=true
                args+=("$1")
                shift
                ;;
              *)
                args+=("$1")
                shift
                ;;
            esac
          done

          # fall back to the terminal width, or 80 columns if that can't be
          # determined (e.g. no controlling tty), when --width wasn't given
          width="''${width:-$(tput cols 2>/dev/null || echo 80)}"

          if [[ "$display_set" == false ]]; then
            if [[ "$width" -lt 140 ]]; then
              mode=inline
            else
              mode=side-by-side
            fi
            echo "mode: $mode"
            args=(--display "$mode" "''${args[@]}")
          fi

          echo "width: $width; ''${args[*]}"
          exec "${final.lib.getExe prev.difftastic}" "''${args[@]}"
        '';
      };
    })
  ];

  flake.modules.homeManager.difftastic = { pkgs, ... }: {
    home.packages = [ pkgs.difftastic ];
  };
}
