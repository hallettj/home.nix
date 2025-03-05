{ pkgs, ... }:

let
  difftastic = pkgs.difftastic;
  difft = "${difftastic}/bin/difft";
in
{
  home.packages = [
    difftastic
  ];

  programs.git = {
    enable = true;
    userName = "Jesse Hallett";
    userEmail = "jesse@sitr.us";
    signing.key = "A5CC2BE3";

    aliases = {
      di = "diff --cached";
      lg = "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
      commend = "commit --amend --no-edit";
      it = "!git init && read -p 'Committer email address for this repo: ' email && git config user.email $email && git commit -m 'initial commit' --allow-empty";
      up = "git fetch origin main:main";
    };

    ignores = [ "*.swo" "*.swp" ];

    extraConfig = {
      column.ui = "auto"; # columns display for status, branches, tags
      branch.sort = "-committerdate";
      core = {
        pager = "less -FR";
        autocrlf = "input";
        editor = "nvim";
      };
      color.diff = {
        oldMoved = "magenta";
        oldMovedAlternative = "#ea76cb"; # pink
        newMoved = "cyan";
        newMovedAlternative = "#179299"; # teal
      };
      diff = {
        algorithm = "histogram";
        colorMoved = "zebra"; # highlight moved lines with distinct colors for adjacent blocks moved to/from different places
        mnemonicPrefix = true; # replace a/ b/ in diffs with initials for index, worktree, commit
        renames = true; # turn on file rename detection
      };
      fetch = {
        prune = true; # delete origin/ branch pointers locally when upstream branches are removed
        pruneTags = true; # same for tags
        all = true; # apply pruning to all branches
      };
      init.defaultBranch = "main";
      merge.conflictstyle = "zdiff3"; # three-way conflict markers instead of two-way
      push = {
        default = "simple";
        followTags = true; # automatically push tags, like `push --tags`
      };
      pull.ff = "only";
      tag.sort = "version:refname"; # sorts semver strings
      user.useConfigOnly = true;

      # Settings given in difftastic manual https://difftastic.wilfred.me.uk/git.html
      diff.external = "${difft} --display side-by-side";
      diff.tool = "difftastic";
      difftool.prompt = false;
      "difftool \"difftastic\"".cmd = ''${difft} "$LOCAL" "$REMOTE"'';
      pager.difftool = true;

      rebase = {
        autosquash = true; # automatically squash fixups, etc.
        updateRefs = true; # force-update branch pointers to rebased commits
      };
      rerere = {
        # record rebase conflict solutions to re-apply if needed
        enabled = true;
        autoupdate = true;
      };
    };
  };
}
