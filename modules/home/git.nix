{ config, lib, pkgs, ... }:

{
  programs.git = {
    enable = true;
    userName = "Tobin Elavathil";
    userEmail = "tobin.elavathil@gmail.com";
    
    delta = {
      enable = true;
      options = {
        navigate = true;
        side-by-side = true;
        line-numbers = true;
        syntax-theme = "Monokai Extended";
        light = false;
        color-only = true;
      };
    };

    aliases = {
      # View abbreviated SHA, description, and history graph of the latest 20 commits
      l = "log --pretty=oneline -n 20 --graph --abbrev-commit";

      # View the current working tree status using the short format
      s = "status -s";

      # Show the diff between the latest commit and the current state
      d = "!git diff-index --quiet HEAD -- || clear; git --no-pager diff --patch-with-stat";

      # Pull in remote changes for the current repository and all its submodules
      p = "!git pull; git submodule foreach git pull origin master";

      # Clone a repository including all submodules
      c = "clone --recursive";

      # Commit all changes
      ca = "!git add -A && git commit -av";

      # Switch to a branch, creating it if necessary
      go = "!f() { git checkout -b \"$1\" 2> /dev/null || git checkout \"$1\"; }; f";

      # Show verbose output about tags, branches or remotes
      tags = "tag -l";
      branches = "branch -a";
      remotes = "remote -v";

      # Amend the currently staged files to the latest commit
      amend = "commit --amend --reuse-message=HEAD";

      # Credit an author on the latest commit
      credit = "!f() { git commit --amend --author \"$1 <$2>\" -C HEAD; }; f";

      # Interactive rebase with the given number of latest commits
      reb = "!r() { git rebase -i HEAD~$1; }; r";

      # Remove the old tag with this name and tag the latest commit with it.
      retag = "!r() { git tag -d $1 && git push origin :refs/tags/$1 && git tag $1; }; r";

      # Find branches containing commit
      fb = "!f() { git branch -a --contains $1; }; f";

      # Find tags containing commit
      ft = "!f() { git describe --always --contains $1; }; f";

      # Find commits by source code
      fc = "!f() { git log --pretty=format:'%C(yellow)%h  %Cblue%ad  %Creset%s%Cgreen  [%cn] %Cred%d' --decorate --date=short -S$1; }; f";

      # Find commits by commit message
      fm = "!f() { git log --pretty=format:'%C(yellow)%h  %Cblue%ad  %Creset%s%Cgreen  [%cn] %Cred%d' --decorate --date=short --grep=$1; }; f";

      # Remove branches that have already been merged with master
      dm = "!git branch --merged | grep -v '\\*' | xargs -n 1 git branch -d";

      # List contributors with number of commits
      contributors = "shortlog --summary --numbered";

      # Merge GitHub pull request on top of the master branch
      mpr = "!f() { if [ $(printf \"%s\" \"$1\" | grep '^[0-9]\\+$' > /dev/null; printf $?) -eq 0 ]; then git fetch origin refs/pull/$1/head:pr/$1 && git rebase master pr/$1 && git checkout master && git merge pr/$1 && git branch -D pr/$1 && git commit --amend -m \"$(git log -1 --pretty=%B)\\n\\nCloses #$1.\"; fi }; f";

      # Resolve all conflicts
      "resolve-all" = "!sh -c \"git status --porcelain | awk '/^(UU|AA)/ {print \\$2}' | xargs -I {} git checkout --$1 {}\"";
    };

    extraConfig = {
      apply = {
        whitespace = "fix";
      };

      core = {
        excludesfile = "~/.gitignore";
        attributesfile = "~/.gitattributes";
        whitespace = "space-before-tab,-indent-with-non-tab,trailing-space";
        trustctime = false;
        precomposeunicode = false;
        pager = "delta";
        editor = "cursor --wait";
      };

      color = {
        ui = "auto";
        branch = {
          current = "yellow reverse";
          local = "yellow";
          remote = "green";
        };
        diff = {
          meta = "yellow bold";
          frag = "magenta bold";
          old = "red";
          new = "green";
        };
        status = {
          added = "yellow";
          changed = "green";
          untracked = "cyan";
        };
      };

      delta = {
        navigate = true;
        light = false;
      };

      diff = {
        renames = "copies";
        colorMoved = "default";
      };

      help = {
        autocorrect = 1;
      };

      interactive = {
        diffFilter = "delta --color-only";
      };

      "add.interactive" = {
        useBuiltin = false;
      };

      merge = {
        log = true;
        conflictStyle = "zdiff3";
      };

      push = {
        default = "current";
        followTags = true;
        autoSetupRemote = true;
      };

      "url \"git@github.com:\"" = {
        insteadOf = "gh:";
        pushInsteadOf = [ "github:" "git://github.com/" ];
      };

      "url \"git://github.com/\"" = {
        insteadOf = "github:";
      };

      "url \"git@gist.github.com:\"" = {
        insteadOf = "gst:";
        pushInsteadOf = [ "gist:" "git://gist.github.com/" ];
      };

      "url \"git://gist.github.com/\"" = {
        insteadOf = "gist:";
      };

      credential.helper = "cache";
      init.defaultBranch = "main";
    };

    ignores = [
      # IntelliJ IDEA IDE
      ".idea"
      # VSCode IDE
      ".vscode"
      # Compiled Python files
      "*.pyc"
      # Folder view configuration files
      ".DS_Store"
      "Desktop.ini"
      # Thumbnail cache files
      "._*"
      "Thumbs.db"
      # Files that contain credentials or personal info
      ".extra"
      ".boto"
      ".mrjob.conf"
      ".s3cfg"
      ".aws/"
      # Repo scratch directory
      "scratch/"
      # env vars
      ".env"
      ".envrc"
    ];
  };
}
