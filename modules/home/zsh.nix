{ config, lib, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    
    history = {
      size = 10240000;
      save = 10240000;
      path = "${config.home.homeDirectory}/.zsh_history";
      extended = true;
      ignoreDups = true;
      share = true;
    };

    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "z"
        "common-aliases"
        "history"
        "command-not-found"
        "docker"
      ];
    };

    plugins = [
      {
        name = "zsh-completions";
        src = pkgs.fetchFromGitHub {
          owner = "zsh-users";
          repo = "zsh-completions";
          rev = "0.34.0";
          sha256 = "0jnvhwc1dzk7z0zqxd7c1ihmhx7j7k5guv7gvf3m3zz1b56jc3zz";
        };
      }
      {
        name = "zsh-autosuggestions";
        src = pkgs.fetchFromGitHub {
          owner = "zsh-users";
          repo = "zsh-autosuggestions";
          rev = "v0.7.0";
          sha256 = "0z6i9wjjklb4lvr7zjhbphibsyx51psv50gm07mbb0kj9058j6kc";
        };
      }
      {
        name = "zsh-history-substring-search";
        src = pkgs.fetchFromGitHub {
          owner = "zsh-users";
          repo = "zsh-history-substring-search";
          rev = "v1.0.2";
          sha256 = "0y8va5kc2ram38hbk2cibkk64ffrabfv1sh4xm7pjspsba9n5p1y";
        };
      }
      {
        name = "fast-syntax-highlighting";
        src = pkgs.fetchFromGitHub {
          owner = "zdharma-continuum";
          repo = "fast-syntax-highlighting";
          rev = "v1.55";
          sha256 = "0h7f27gz586xxw7cc0wyiv3bx0x3qih2wwh05ad85bh2h834ar8d";
        };
      }
    ];

    envExtra = ''
      export LSCOLORS='exfxcxdxbxegedabagacad'
      export CLICOLOR=true
      export CURSOR_EDITOR=cursor
      export EDITOR="$CURSOR_EDITOR -w"
      export VISUAL=$EDITOR
      export TERM="xterm-256color"
      export PAGER='less'
      export LESS='-giAMR'
      export LC_ALL=en_US.UTF-8
      export LANG=en_US.UTF-8
    '';

    initExtra = ''
      # bind keys for history search
      bindkey '^[[A' history-substring-search-up
      bindkey '^[[B' history-substring-search-down

      # Better program aliases if installed
      if command -v eza > /dev/null; then alias ls='eza'; fi
      if command -v bat > /dev/null; then alias cat='bat'; fi
      if command -v htop > /dev/null; then alias top='htop'; fi
      if command -v dfc > /dev/null; then alias df='dfc'; fi
      if command -v dust > /dev/null; then alias du='dust'; fi
      if command -v procs > /dev/null; then alias ps='procs'; fi
    '';

    shellAliases = {
      # Git aliases
      gundo = "git reset --soft HEAD~1";
      grbim = "git rebase -i main";
      gfix = "git commit -v -a --no-edit --amend && git push --force-with-lease";
      gdl = "git --no-pager diff --name-only";
      
      # Docker aliases
      dps = "docker ps";
      dpsa = "docker ps -a";
      dimg = "docker images";
      drm = "docker rm";
      drmi = "docker rmi";
      drun = "docker run";
      dbuild = "docker build";
      dexec = "docker exec -it";
    };
  };
}
