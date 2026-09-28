{ self, ... }:
{
  flake.modules.nixos.development = {
    imports = with self.modules.nixos; [
      claude-anthropic
    ];

    # Prevent intermediate outputs from crate2nix and direnv from getting
    # garbage-collected, as long as there is a gc root holding on to
    # a derivation that the intermediate outputs were used to build.
    nix.settings.keep-outputs = true;

    # Hardware-accelerated emulation
    users.users.jesse.extraGroups = [ "kvm" ];
  };

  flake.modules.homeManager.development =
    { pkgs, ... }:
    {
      imports = with self.modules.homeManager; [
        # features
        difftastic
        jujutsu
        neovim
        tig
      ];

      home.packages = with pkgs; [
        # Programming
        cargo
        claude-code
        docker
        docker-compose
        rustc
        rust-analyzer
        clang
        nodejs
        python315

        # Environment
        devenv
      ];
    };
}
