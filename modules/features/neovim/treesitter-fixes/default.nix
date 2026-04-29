{ ... }:

let
  overlay = final: prev: {
    vimPlugins = prev.vimPlugins.extend (
      plugins-final: plugins-prev: {

        # Reduce highlight priority of strings in Rust code so that string
        # highlight does not override treesitter language injection highlights.
        #
        # We have to patch nvim-treesitter's src attribute instead of patching
        # the usual way because built queries get their src from
        # nvim-treesitter.src.
        nvim-treesitter = plugins-prev.nvim-treesitter.overrideAttrs (attrs: {
          src = final.applyPatches {
            src = attrs.src;
            patches = [ ./nvim-treesitter_reduce-string-priority.patch ];
          };
        });
      }
    );
  };
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
