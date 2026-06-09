{
  nixpkgs.overlays = [
    (final: prev: {
      wvkbd = prev.wvkbd.overrideAttrs (attrs: {
        makeFlags = [ "LAYOUT=deskintl" ];
        meta = attrs.meta // {
          mainProgram = "wvkbd-deskintl";
        };
      });
    })
  ];

  perSystem = { pkgs, ... }: { packages.wvkbd = pkgs.wvkbd; };

  # While the keyboard is running in the background:
  #
  # - show with: pkill wvkbd-deskintl -SIGUSR2
  # - hide with: pkill wvkbd-deskintl -SIGUSR1
  # - toggle with: pkill wvkbd-deskintl -SIGRTMIN
  #
  flake.modules.homeManager.niri-virtual-keyboard =
    { pkgs, ... }:
    let
      run-wvkdb = pkgs.writeShellApplication {
        name = "run-wvkdb";
        runtimeInputs = with pkgs; [ wvkbd ];
        text = ''
          killall wvkbd-deskintl || true
          (wvkbd-deskintl --hidden &) || true
        '';
      };
    in
    {
      programs.niri.settings.switch-events = {
        tablet-mode-on.action.spawn = [ "run-wvkdb" ];
        tablet-mode-off.action.spawn = [
          "pkill"
          "wvkbd-deskintl"
        ];
      };

      home.packages = [
        pkgs.wvkbd
        run-wvkdb
      ];
    };
}
