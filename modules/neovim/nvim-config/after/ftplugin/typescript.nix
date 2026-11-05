{
  perSystem =
    { pkgs, self', ... }:
    let
      # Tests for the angle bracket pairing set up in typescript.lua. These run
      # against my actual neovim package, so they also check that mini.pairs is
      # enabled and that this ftplugin is part of the installed configuration.
      test-script = pkgs.writeText "typescript-pairs-test.lua" /* lua */ ''
        -- The configuration starts language servers on FileType. The tests do
        -- not need them, and the servers are not reachable in the build sandbox.
        pcall(vim.api.nvim_del_augroup_by_name, "nvim.lsp.enable")

        vim.o.showmode = false -- keeps "-- INSERT --" out of the test output

        assert(package.loaded["mini.pairs"] ~= nil, "mini.pairs is not loaded")

        local function termcodes(keys) return vim.api.nvim_replace_termcodes(keys, true, false, true) end

        -- Put `pre` in a buffer of filetype `ft`, then type `keys` in insert
        -- mode at `col` (0-based byte column, defaults to the end of the line).
        --
        -- NOTE: each case has to pre-fill the text that precedes the cursor and
        -- type only the trigger key. Typing a whole line in one `feedkeys` call
        -- does not work, because the characters are fed faster than they are
        -- flushed into the buffer, so the mappings end up testing a stale line.
        -- mini.pairs' own built-in rules misbehave the same way under batched
        -- `feedkeys`, so this is an artifact of the test, not of the mappings.
        local function typed(ft, pre, keys, col)
          vim.cmd "enew!"
          vim.bo.filetype = ft
          vim.api.nvim_buf_set_lines(0, 0, -1, false, { pre })
          local enter_insert = "A"
          if col ~= nil then
            vim.api.nvim_win_set_cursor(0, { 1, col })
            enter_insert = "i"
          end
          vim.api.nvim_feedkeys(enter_insert .. termcodes(keys) .. termcodes "<Esc>", "tx", false)
          return vim.api.nvim_get_current_line()
        end

        local failures = 0
        local function check(label, got, want)
          if got ~= want then
            failures = failures + 1
            print(string.format("FAIL %s -> %q (expected %q)", label, got, want))
          end
        end

        -- Typing "<" where a generic or a tag can start pairs it
        local pairing_cases = {
          { "typescript", "Array", "Array<>" },
          { "typescript", "const x: Promise", "const x: Promise<>" },
          { "typescript", "const f = ", "const f = <>" },
          { "typescript", "  return ", "  return <>" },
          { "typescript", "type A = B extends ", "type A = B extends <>" },
          { "typescript", "foo(", "foo(<>" },
          { "typescript", "  ", "  <>" },
          { "typescriptreact", "  return ", "  return <>" },
          { "typescriptreact", "  const el = cond ? ", "  const el = cond ? <>" },
          { "typescriptreact", "  items.map((x) => ", "  items.map((x) => <>" },
          { "typescriptreact", "    ", "    <>" },
        }
        for _, case in ipairs(pairing_cases) do
          local label = string.format('[%s] %q + "<"', case[1], case[2])
          check(label, typed(case[1], case[2], "<"), case[3])
        end

        -- Typing "<" after a complete expression is an inequality test, which
        -- must not pair. In the two cases with no space it is only the closing
        -- bracket that distinguishes the comparison from a generic.
        local comparison_cases = {
          { "typescript", "if (a " },
          { "typescript", "if (a.b " },
          { "typescript", "while (i " },
          { "typescript", "if (1 " },
          { "typescript", 'if (name === "a" ' },
          { "typescript", "if (f() " },
          { "typescript", "if (arr[i] " },
          { "typescript", "if (f()" },
          { "typescript", "if (arr[i]" },
          -- "<" is not mapped outside of TypeScript
          { "lua", "if a " },
          { "lua", "local t = x" },
        }
        for _, case in ipairs(comparison_cases) do
          local label = string.format('[%s] %q + "<"', case[1], case[2])
          check(label, typed(case[1], case[2], "<"), case[2] .. "<")
        end

        -- Finishing a JSX tag, and opening its closing tag
        check("tsx tag", typed("typescriptreact", "  <div", ">"), "  <div>")
        check("tsx closing tag", typed("typescriptreact", "  <div>", "</div"), "  <div></div>")

        -- ">" types over the ">" of a pair instead of adding a second one
        check("type over >", typed("typescript", "Array<>", ">", 6), "Array<>")

        -- <BS> in a "<>" pair deletes both characters
        check("<BS> in pair", typed("typescript", "Array<>", "<BS>", 6), "Array")

        -- <CR> is deliberately not registered for "<>", so it just splits the
        -- line instead of also opening a blank line inside the pair
        typed("typescript", "Array<>", "<CR>", 6)
        check("<CR> in pair", table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), "|"), "Array<||>")

        if failures > 0 then
          print(failures .. " failure(s)")
          os.exit(1)
        end
        print "all tests passed"
        os.exit(0)
      '';
    in
    {
      checks.neovim-typescript-pairs =
        pkgs.runCommand "neovim-typescript-pairs-test"
          {
            nativeBuildInputs = [ self'.packages.neovim ];
          }
          ''
            set -o pipefail
            # Neovim writes state (shada is off, but not everything is) under
            # $HOME, which does not exist in the build sandbox.
            export HOME="$(mktemp -d)"
            nvim -i NONE --headless -c 'luafile ${test-script}' -c 'qa!' 2>&1 | tee "$out"
          '';
    };
}
