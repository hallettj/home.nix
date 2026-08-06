{ inputs, ... }:

{
  flake-file.inputs = {
    git-format-staged = {
      url = "https://flakehub.com/f/hallettj/git-format-staged/4.*";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    git-hooks = {
      url = "github:ysndr/nix-git-hooks/d48aa6c86f9ded84e342e60ebebf8f973a891aa9";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  nixpkgs.overlays = [ inputs.git-hooks.overlay ];

  perSystem =
    {
      inputs',
      pkgs,
      self',
      ...
    }:
    {
      packages = {
        format-staged-changes = pkgs.writeShellApplication {
          name = "format-staged-changes";
          runtimeInputs = with pkgs; [
            inputs'.git-format-staged.packages.default
            nixfmt
            prettier
            stylua
          ];
          text = ''
            git-format-staged --formatter 'nixfmt --filename {}' '*.nix'
            git-format-staged --formatter 'prettier --stdin-filepath {}' '*.json' '*.md'
            git-format-staged --formatter 'stylua --stdin-filepath {} -' '*.lua'
          '';
        };

        hook-installer = pkgs.git-hook-installer {
          pre-commit = with self'.packages; [
            format-staged-changes
          ];
        };
      };

      devShells.git-format-staged = pkgs.mkShell {
        inputsFrom = [
          self'.packages.format-staged-changes
        ];

        packages = [
          self'.packages.hook-installer
        ];

        shellHook = /* bash */ ''
          install-git-hooks
        '';
      };
    };
}
