# home.nix
# Main Home Manager configuration file
{ config, pkgs, ... }:

{
  imports = [
    ./modules/home/git.nix
    ./modules/home/zsh.nix
    ./modules/home/starship.nix
  ];

  # Home Manager needs a bit of information about you and the paths it should manage
  home = {
    username = "tobin";
    homeDirectory = "/Users/tobin";

    # Packages that should be installed to the user profile
    packages = with pkgs; [
      # Development tools
      ripgrep
      fd
      bat
      eza
      delta
      fzf
      jq
      yq
      direnv
      zoxide
      chezmoi
      antigen
      git-lfs
      mkcert
      rcm
      reattach-to-user-namespace
      sd
      shared-mime-info
      universal-ctags
      watchman

      # AWS tools
      awscli
      session-manager-plugin

      # Node.js development
      nodejs
      yarn
      pkg-config
      pixman
      cairo
      pango

      # Python development
      python3
      poetry
      black
      pylint

      # HashiCorp tools
      consul
      nomad
      terraform
      terraform-ls
      vault

      # Image manipulation
      imagemagick

      # Programming language prerequisites
      libyaml
      coreutils
      gnupg

      # Database tools
      postgresql_14
    ];

    sessionVariables = {
      EDITOR = "vim";
      VISUAL = "vim";
      LANG = "en_US.UTF-8";
      LC_ALL = "en_US.UTF-8";
      FZF_DEFAULT_COMMAND = "rg --files --hidden --smart-case --follow --glob '!.git/*'";
      FZF_CTRL_T_COMMAND = "rg --files --hidden --smart-case --follow --glob '!.git/*'";
    };

    file = {
      ".default-gems".text = "bundler";
      ".default-npm-packages".text = "yarn";
    };

    # This value determines the Home Manager release
    stateVersion = "23.11";
  };

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;

  # Additional program configurations
  programs = {
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    fzf = {
      enable = true;
      enableZshIntegration = true;
    };

    bat = {
      enable = true;
      config = {
        theme = "TwoDark";
        italic-text = "always";
      };
    };

    # ASDF version manager
    asdf = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      plugins = [
        {
          name = "ruby";
          repository = "https://github.com/asdf-vm/asdf-ruby.git";
        }
        {
          name = "nodejs";
          repository = "https://github.com/asdf-vm/asdf-nodejs.git";
        }
        {
          name = "python";
        }
        {
          name = "yarn";
        }
        {
          name = "golang";
        }
        {
          name = "terraform";
        }
        {
          name = "shellcheck";
        }
        {
          name = "nomad";
        }
      ];
    };
  };
}
