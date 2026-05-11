{ ... }:

let
  overlay = final: prev: {
    vimPlugins = prev.vimPlugins.extend (
      plugins-final: plugins-prev: {

        # Reduce highlight priority of strings in Rust code so that string
        # highlight does not override treesitter language injection highlights.
        nvim-treesitter = patch plugins-prev.nvim-treesitter [
          ./nvim-treesitter_reduce-string-priority.patch
        ];
      }
    );
  };

  patch =
    pkg: patches:
    pkg.overrideAttrs (oldAttrs: {
      patches = (oldAttrs.patches or [ ]) ++ patches;
    });
in
{
  # This patch is required to get the patch to nvim-treesitter to propagate to
  # packages for built queries.
  #
  # Note that this option and the overlays option below require my custom module
  # in modules/nixpkgs.nix
  nixpkgs-unstable.patches = [ ./make-overlays-to-nvim-treesitter-affect-built-queries.patch ];

  nixpkgs.overlays = [
    overlay
    (final: prev: {
      unstable = prev.unstable.extend overlay;
    })
  ];
}
