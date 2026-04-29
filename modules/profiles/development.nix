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
      ];
    };
}
