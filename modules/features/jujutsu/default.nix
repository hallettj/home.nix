# Set up jujutsu version control system, a.k.a. jj
{
  inputs,
  withSystem,
  ...
}:

{
  flake-file.inputs = {
    difftastic-nvim = {
      url = "github:clabby/difftastic.nvim";
      flake = false;
    };
    oyui = {
      # url = "github:emilien-jegou/oyui";
      url = "github:hallettj/oyui/override-default-key-bindings";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  flake.modules.homeManager.jujutsu =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      difftastic = pkgs.difftastic;
      difft = lib.getExe difftastic;
      jjui = pkgs.unstable.jjui;
      jj-starship = lib.getExe pkgs.jj-starship;
      oyui = inputs.oyui.packages.${pkgs.stdenv.hostPlatform.system}.default;
    in
    {
      programs.jujutsu = {
        enable = true;
        settings = {
          user = {
            name = "Jesse Hallett";
            email = "jesse@sitr.us";
          };
          revsets = {
            bookmark-advance-to = "closest_pushable(@)";
          };
          revset-aliases = {
            # Revisions that should not be pushed to a git remote
            "private()" = "description(regex:'^wip\\b') | description('wip:*') | description('private:*')";

            # Closest revision that is mutable, non-private, has a description, is either non-empty or a merge
            "closest_pushable(to)" = ''
              heads(::to & mutable() & ~private():: & ~description(exact:"") & (~empty() | merges()))
            '';
          };
          git = {
            private-commits = "private()";
          };
          ui = {
            default-command = [
              "util"
              "exec"
              "--"
              (lib.getExe jjui)
            ];
            diff-editor = "hunk";
            diff-formatter = "difft";
            diff-instructions = false;
            merge-editor = "mergiraf";
          };
          merge-tools.difft = {
            program = difft;
            edit-args = [ ]; # not used for editing
            diff-args = [
              "--color=always"
              "--width=$width"
              "$left"
              "$right"
            ];
          };

          # Diff editor via hunk.nvim neovim plugin, designed for jj
          merge-tools.hunk = {
            program = withSystem pkgs.stdenv.hostPlatform.system (
              { self', ... }: lib.getExe self'.packages.neovim
            );
            edit-args = [
              "-c"
              "DiffEditor $left $right $output"
            ];
            diff-args = [ ]; # not used for diff display
          };

          # Standalone diff editor, designed for jj
          merge-tools.oyui = {
            program = lib.getExe' oyui "oyui";
            edit-args = [
              "diff"
              "$left"
              "$right"
            ];
            diff-args = [ ]; # not used for diff display
          };

          aliases = {
            # Advance bookmark, and run jj fix;
            tug =
              let
                tug-script = pkgs.writeNushellApplication {
                  name = "jj-tug";
                  runtimeInputs = [ config.programs.jujutsu.package ];
                  text = /* nu */ ''
                    def main [
                      ...names: string # Move bookmarks matching the given name patterns
                      --to (-t): string # Move bookmarks to this revision
                    ] {
                        # Mirror the defaults that `jj bookmark advance` would compute internally, so
                        # that the revset used for `jj fix -s` below matches what advance will move.
                        let target = $to | default (jj config get revsets.bookmark-advance-to)
                        let bookmark = if ($names | is-empty) {
                            $"heads\(::\(($target)\) & bookmarks\(\)\)"
                        } else {
                            let patterns = ($names | each {|n| $"bookmarks\(($n)\)" } | str join " | ")
                            $"heads\(::\(($target)\) & \(($patterns)\)\)"
                        }
                        # Run fix if fix.tools are configured
                        if (jj config get fix.tools | complete | get exit_code) == 0 {
                            jj fix -s $"($bookmark)..\(($target)\) & mutable\(\)" # fix revisions after bookmark, up to and including target
                        }
                        jj bookmark advance ...$names --to $target
                    }
                  '';
                };
              in
              [
                "util"
                "exec"
                "--"
                (lib.getExe tug-script)
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
            "--truncate-name=18"
          ];
          format = "$output ";
        };
        # The jj module shows git status in non-jj repos
        git_branch.disabled = true;
        git_commit.disabled = true;
        git_status.disabled = true;
      };

      xdg.configFile."oyui/config.rn".text = /* rust */ ''
        pub fn config() {
          theme::set("catppuccin-macchiato");
          keybind("c", || global::confirm());
          keybind("enter", || global::unset());
          keybind("j", || view::tree::directory::expand());
          keybind("k", || view::tree::directory::collapse());
          on_mode("file", || {
            keybind("left", || view::file::close());
            keybind("right", || view::file::scroll::left(0));
            keybind("(", || view::file::nav::prev_hunk());
            keybind(")", || view::file::nav::next_hunk());
            keybind("-", || view::file::staging::toggle());
          });
        }
      '';

      home.packages = [
        difftastic
        jjui
        pkgs.jj-starship
        pkgs.mergiraf # headless, automatic conflict resolver
        oyui # diff editor
      ];
    };

  # Configure neovim for jj integration
  flake.nvim-config.jj =
    { pkgs, ... }:
    {
      # I also have the picker from snacks.nvim set up in another module because jj uses it.
      specs.jj = {
        data = with pkgs.unstable.vimPlugins; [
          codediff-nvim # nixpkgs unstable has v2.49 which includes compact diff mode
          jj-nvim
        ];
        config = /* lua */ ''
          require("codediff").setup {
            diff = {
              compact = true,
              compact_context_lines = 12,
            },
          }

          local jj = require "jj"
          jj.setup {
            diff = { backend = "codediff" },
            keymaps = {
              close = { "q" },
              log = {
                resolve = "gR",
              },
            },
            terminal = { window = { type = "hsplit" } },
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
          vim.keymap.set("n", "<leader>dd", function() vim.cmd "CodeDiff" end, { desc = "diff of working copy" })
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

      # Hunk.nvim is a diff editor for use with jj commands like `split`
      specs.hunk = {
        data = pkgs.vimPlugins.hunk-nvim;
        config = /* lua */ ''
          require("hunk").setup {
            -- customize keys to be a little more like fugitive
            keys = {
              tree = {
                toggle_file = { "-", "a" },
              },
              diff = {
                toggle_hunk = { "-", "A" },

                prev_hunk = { "(", "[h" },
                next_hunk = { ")", "]h" },
              },
            },
          }
        '';
      };

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
}
