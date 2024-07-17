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
      user.useConfigOnly = true;
      push.default = "simple";
      pull.ff = "only";
      core = {
        pager = "less -FR";
        autocrlf = "input";
        editor = "nvim";
      };

      # Settings given in difftastic manual https://difftastic.wilfred.me.uk/git.html
      diff.external = "${difft} --display side-by-side";
      diff.tool = "difftastic";
      difftool.prompt = false;
      "difftool \"difftastic\"".cmd = ''${difft} "$LOCAL" "$REMOTE"'';
      pager.difftool = true;

      rebase.autosquash = true;
      rerere = {
        enabled = true;
        autoupdate = true;
      };
      init = {
        defaultBranch = "main";
      };
    };
  };
}
