{
  flake.nvim-config.blink =
    { pkgs, ... }:
    {
      specs.blink = {
        data = pkgs.vimPlugins.blink-cmp;
        name = "blink";
        config = /* lua */ ''
          require("blink.cmp").setup {
            keymap = { preset = "enter" },
            appearance = {
              -- Sets the fallback highlight groups to nvim-cmp's highlight groups
              -- Useful for when your theme doesn't support blink.cmp
              -- Will be removed in a future release
              use_nvim_cmp_as_default = true,
              -- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
              -- Adjusts spacing to ensure icons are aligned
              nerd_font_variant = "mono",
            },
            completion = {
              menu = {
                draw = {
                  columns = { { "kind_icon" }, { "label", "label_description", gap = 1 }, { "source_name" } },
                },
              },
              list = {
                selection = {
                  preselect = false, -- this setting works better with the 'enter' keymap preset
                  auto_insert = false, -- don't put text into buffer when selecting, only on accept
                },
              },
            },
            cmdline = {
              keymap = {
                preset = "inherit",
                ["<CR>"] = { "accept_and_enter", "fallback" }, -- default <cr> accepts, but does not immediately execute
              },
              completion = {
                list = { selection = { preselect = false } },
                menu = {
                  auto_show = function(ctx)
                    return vim.fn.getcmdtype() == ":" -- normal command
                      or vim.fn.getcmdtype() == "@" -- input() command
                  end,
                },
              },
            },
            sources = {
              default = { "lsp", "path", "snippets", "buffer" },
            },
          }
        '';
      };
    };
}
