{ self, ... }:
{
  flake.modules.nixos.development = {
    imports = with self.modules.nixos; [
      claude-anthropic
    ];
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

        # Environment
        devenv
      ];
    };
}
