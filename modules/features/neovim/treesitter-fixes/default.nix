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
  nixpkgs.overlays = [
    overlay
    (final: prev: {
      unstable = prev.unstable.extend overlay;
    })
  ];
}
