{
  flake.nvim-config.autopairs =
    { pkgs, ... }:
    {
      specs.autopairs = {
        data = pkgs.vimPlugins.nvim-autopairs;
        config = /* lua */ ''
          local Rule = require "nvim-autopairs.rule"
          local cond = require "nvim-autopairs.conds"

          require("nvim-autopairs").setup {
            -- By default autopairs refuses to add a close pair when the next
            -- character is one of [%w%%%'%[%"%.%`%$] - i.e. typing "(" just
            -- before a word, quote, or bracket inserts an unmatched "(". That
            -- is the main source of unbalanced delimiters. Empty string turns
            -- the check off entirely so a close pair is always added. (If
            -- always-pairing gets noisy mid-word, "[%w%.]" is the middle
            -- ground: skip only before word characters and dots.)
            ignored_next_char = "",

            -- Use nvim-surround to wrap existing text, rather than relying on
            -- autopairs declining to pair.

            -- NOTE: enable_check_bracket_line is deliberately left at its
            -- default of true. It installs two balance-aware conditions:
            -- typing "(" before an unmatched ")" skips the close pair, and -
            -- more importantly - typing ")" next to an existing ")" inserts a
            -- real ")" instead of skipping over it when the line is not
            -- balanced. Setting it to false disables both, which makes
            -- autopairs type over close brackets it should have inserted.
            enable_check_bracket_line = false,

            -- NOTE: check_ts is deliberately not set. In this plugin it only
            -- *suppresses* pairing: it wraps the quote/bracket rules in a
            -- condition that declines to pair when the cursor sits inside one
            -- of the treesitter node types listed in ts_config. The built-in
            -- ts_config disables pairing inside Lua strings (string, source,
            -- string_content) and JavaScript strings and template strings, so
            -- check_ts = true produced *more* unbalanced delimiters, not
            -- fewer.
          }

          -- Close angle brackets in TypeScript. "<" is not a pair by default
          -- because in most languages it is a comparison operator. The
          -- before_regex guard limits pairing to the case where "<" follows an
          -- identifier character, which is what generics look like
          -- (Array<, Promise<, Record<) and is not what a comparison looks
          -- like ("a < b" has a space before the "<").
          --
          -- NOTE: ignored_next_char above only affects the plugin's built-in
          -- rules (see rules/basic.lua), so this rule pairs regardless of what
          -- follows the cursor - matching the always-pair behavior configured
          -- there.
          --
          -- NOTE: with_move is what maps ">" to type over an existing ">"
          -- instead of inserting a second one; without any move condition
          -- nvim-autopairs does not map the close key at all.
          require("nvim-autopairs").add_rules {
            Rule("<", ">", { "typescript", "typescriptreact" })
              :with_pair(cond.before_regex "[%w_$]")
              :with_move(function(opts) return opts.char == ">" end),
          }
        '';
      };
    };
}
