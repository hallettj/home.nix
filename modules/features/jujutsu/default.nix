# Set up jujutsu version control system, a.k.a. jj
{
  config,
  inputs,
  self,
  ...
}:

{
  flake-file.inputs = {
    difftastic-nvim = {
      url = "github:clabby/difftastic.nvim";
      flake = false;
    };
  };

  flake.modules.homeManager.jujutsu =
    { lib, pkgs, ... }:
    let
      difftastic = pkgs.difftastic;
      difft = lib.getExe difftastic;
      jj-starship = lib.getExe pkgs.jj-starship;
    in
    {
      programs.jujutsu = {
        enable = true;
        settings = {
          user = {
            name = "Jesse Hallett";
            email = "jesse@sitr.us";
          };
          git = {
            private-commits = "description(regex:'^wip\\b') | description('wip:*') | description('private:*')";
          };
          ui = {
            default-command = [ "log" ];
            diff-editor = [
              (lib.getExe self.packages.${pkgs.stdenv.hostPlatform.system}.neovim-with-diff-editor) # see definition below
              "-c"
              "DiffEditor $left $right $output"
            ];
            diff-formatter = [
              difft
              "--display=side-by-side"
              "--color=always"
              "$left"
              "$right"
            ];
          };
          aliases = {
            tug = [
              "bookmark"
              "move"
              "--from"
              "heads(::@- & bookmarks())"
              "--to"
              "@-"
            ];
          };
        };
      };

      programs.starship.settings = {
        custom.jj = {
          when = "${jj-starship} detect";
          shell = [
            jj-starship
            "--no-git-id"
            "--strip-bookmark-prefix=jesse/,hallettj/"
          ];
          format = "$output ";
        };
        # The jj module shows git status in non-jj repos
        git_branch.disabled = true;
        git_commit.disabled = true;
        git_status.disabled = true;
      };

      home.packages = [
        difftastic
        pkgs.jj-starship
      ];
    };

  # Configure neovim for jj integration
  flake.nvim-config.jj =
    { pkgs, ... }:
    {
      # I also have the picker from snacks.nvim set up in another module because jj uses it.
      specs.jj = {
        data = with pkgs.vimPlugins; [
          codediff-nvim
          jj-nvim
        ];
        config = /* lua */ ''
          require("codediff").setup {}

          local jj = require "jj"
          jj.setup {
            diff = { backend = "codediff" },
            keymaps = {
              close = { "q" },
            },
            terminal = { window = { type = "vsplit" } },
          }

          local cmd = require "jj.cmd"
          local map = vim.keymap.set

          -- Core commands
          local cmd = require "jj.cmd"
          vim.keymap.set("n", "<leader>jj", cmd.log, { desc = "JJ log" })
          vim.keymap.set("n", "<leader>jd", cmd.describe, { desc = "JJ describe" })
          vim.keymap.set("n", "<leader>je", cmd.edit, { desc = "JJ edit" })
          vim.keymap.set("n", "<leader>jn", cmd.new, { desc = "JJ new" })
          vim.keymap.set("n", "<leader>js", cmd.status, { desc = "JJ status" })
          vim.keymap.set("n", "<leader>sj", cmd.squash, { desc = "JJ squash" })
          vim.keymap.set("n", "<leader>ju", cmd.undo, { desc = "JJ undo" })
          vim.keymap.set("n", "<leader>jy", cmd.redo, { desc = "JJ redo" })
          vim.keymap.set("n", "<leader>jr", cmd.rebase, { desc = "JJ rebase" })
          vim.keymap.set("n", "<leader>jbc", cmd.bookmark_create, { desc = "JJ bookmark create" })
          vim.keymap.set("n", "<leader>jbd", cmd.bookmark_delete, { desc = "JJ bookmark delete" })
          vim.keymap.set("n", "<leader>jbm", cmd.bookmark_move, { desc = "JJ bookmark move" })
          -- vim.keymap.set("n", "<leader>jts", cmd.tag_set, { desc = "JJ tag set" })
          -- vim.keymap.set("n", "<leader>jtd", cmd.tag_delete, { desc = "JJ tag delete" })
          -- vim.keymap.set("n", "<leader>jtp", cmd.tag_push, { desc = "JJ tag push" })
          -- vim.keymap.set("n", "<leader>ja", cmd.abandon, { desc = "JJ abandon" })
          vim.keymap.set("n", "<leader>jf", cmd.fetch, { desc = "JJ fetch" })
          vim.keymap.set("n", "<leader>jp", cmd.push, { desc = "JJ push" })
          vim.keymap.set("n", "<leader>jmr", cmd.open_pr, { desc = "JJ open PR/MR from bookmark in current revision or parent" })
          vim.keymap.set(
            "n",
            "<leader>jml",
            function() cmd.open_pr { list_bookmarks = true } end,
            { desc = "JJ open PR/MR listing available bookmarks" }
          )

          local annotate = require "jj.annotate"
          vim.keymap.set("n", "<leader>ja", annotate.file, { desc = "JJ annotate file" })
          vim.keymap.set("n", "<leader>jl", annotate.line, { desc = "JJ annotate line" })

          -- Diff commands
          local diff = require "jj.diff"
          vim.keymap.set("n", "<leader>df", function() diff.open_vdiff() end, { desc = "JJ diff current buffer" })
          vim.keymap.set("n", "<leader>dF", function() diff.open_hdiff() end, { desc = "JJ hdiff current buffer" })

          -- Pickers
          local picker = require "jj.picker"
          vim.keymap.set("n", "<leader>gj", function() picker.status() end, { desc = "JJ Picker status" })
          vim.keymap.set("n", "<leader>jgh", function() picker.file_history() end, { desc = "JJ Picker history" })
          vim.keymap.set("n", "<leader>jgc", function() picker.conflict() end, { desc = "JJ Picker conflicts" })
          vim.keymap.set("n", "<leader>jgs", function() picker.conflict_sections() end, { desc = "JJ Picker conflict sections" })

          -- Some functions like `log` can take parameters
          vim.keymap.set("n", "<leader>jL", function()
            cmd.log {
              revisions = "'all()'", -- equivalent to jj log -r ::
            }
          end, { desc = "JJ log all" })

          -- Community alias for moving bookmarks
          vim.keymap.set("n", "<leader>jt", function()
            cmd.j "tug"
            cmd.log {}
          end, { desc = "JJ tug" })
        '';
      };

      # jj runs nested editor in terminal for commands like `split`
      env.EDITOR = "nvim";

      # AST-aware diff viewer in Neovim with built-in support for jj
      specs.difftastic =
        let
          difftastic-nvim = pkgs.vimUtils.buildVimPlugin {
            pname = "difftastic-nvim";
            version = "0.0.0-unstable";
            src = inputs.difftastic-nvim;
            dependencies = with pkgs.vimPlugins; [
              nui-nvim
            ];
            nativeBuildInputs = with pkgs; [
              rustPlatform.cargoSetupHook
              cargo
              rustc
            ];
            cargoDeps = pkgs.rustPlatform.importCargoLock {
              lockFile = "${inputs.difftastic-nvim}/Cargo.lock";
            };
            buildPhase = ''
              cargo build --release
            '';
            postInstall = ''
              ln -s libdifftastic_nvim.so $out/target/release/difftastic_nvim.so
            '';
          };
        in
        {
          data = difftastic-nvim;
          config = /* lua */ ''
            require("difftastic-nvim").setup {
              snacks_picker = { enabled = true },
            }
          '';
        };

      runtimePkgs = with pkgs; [
        # used by difftastic-nvim
        difftastic

        # Used by jj.nvim as conflict resolution strategies
        meld
        mergiraf
      ];
    };

  # Self-contained neovim configuration specifically to be run by
  # jj for editing diffs - for example for `split` or `squash -i`
  flake.wrappers.neovim-with-diff-editor =
    { pkgs, wlib, ... }:
    {
      imports = with config.flake.nvim-config; [
        wlib.wrapperModules.neovim
        treesitter
        colorscheme-catppuccin
        leap
        surround
        textobjects
        tpope
      ];

      binName = "nvim-with-diff-editor";

      settings = {
        config_directory = ./nvim-config-with-diff-editor;
        dont_link = true; # this is not the primary neovim install - don't link man pages and other stuff
      };

      # Lazy loading helper
      specs.lze = {
        data = pkgs.vimPlugins.lze;
        name = "lze";
      };

      # The hunk.nvim plugin provides the diff editor
      specs.hunk = {
        data = pkgs.vimPlugins.hunk-nvim;
        config = /* lua */ ''
          require("hunk").setup {
            keys = {
              tree = {
                toggle_file = { "-" },
              },
              diff = {
                toggle_hunk = { "-" },
              },
            },
          }
        '';
      };
    };
}
