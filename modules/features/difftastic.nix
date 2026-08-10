{
  # Wrap difftastic to automatically switch display modes depending on terminal
  # width unless a specific mode is set.
  nixpkgs.overlays = [
    (final: prev: {
      difftastic = final.writeShellApplication {
        name = "difftastic";
        runtimeInputs = [ prev.difftastic ];
        text = ''
          # jj provides a $width variable; fall back to the terminal width, or
          # 80 columns if that can't be determined (e.g. no controlling tty)
          width="''${width:-$(tput cols 2>/dev/null || echo 80)}"

          display_set=false
          for arg in "$@"; do
            case "$arg" in
              --display | --display=*)
                display_set=true
                break
                ;;
            esac
          done

          if [[ "$display_set" == false ]]; then
            if [[ "$width" -lt 140 ]]; then
              mode=inline
            else
              mode=side-by-side
            fi
            set -- --display "$mode" "$@"
          fi

          exec difft "$@"
        '';
      };
    })
  ];

  flake.modules.homeManager.difftastic = { pkgs, ... }: {
    home.packages = [ pkgs.difftastic ];
  };
}
