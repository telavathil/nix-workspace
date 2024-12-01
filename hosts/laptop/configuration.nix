# hosts/laptop/configuration.nix
# Main system configuration for macOS
{ config, pkgs, ... }:

{
  # Import modules
  imports = [ 
    ../../modules/system/base.nix
  ];

  # Set hostname
  networking.hostName = "laptop";
  
  # System settings
  system = {
    # Configure keyboard
    keyboard = {
      enableKeyMapping = true;
      remapCapsLockToEscape = true;
    };
    
    # Configure defaults
    defaults = {
      NSGlobalDomain = {
        AppleShowAllExtensions = true;
        AppleShowScrollBars = "Always";
        NSNavPanelExpandedStateForSaveMode = true;
        NSNavPanelExpandedStateForSaveMode2 = true;
        InitialKeyRepeat = 15;
        KeyRepeat = 2;
      };
      
      dock = {
        autohide = true;
        show-recents = false;
        static-only = true;
        mru-spaces = false;
      };
      
      finder = {
        AppleShowAllExtensions = true;
        FXEnableExtensionChangeWarning = false;
        _FXShowPosixPathInTitle = true;
        ShowPathbar = true;
        ShowStatusBar = true;
      };

      trackpad = {
        Clicking = true;
        TrackpadThreeFingerDrag = true;
      };
    };
  };

  # Enable homebrew
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      cleanup = "zap";
    };
    taps = [
      "homebrew/cask-fonts"
      "homebrew/services"
      "homebrew/cask-versions"
      "hashicorp/tap"
    ];
    brews = [
      "mas"  # Mac App Store CLI
    ];
    casks = [
      # Browsers
      "firefox"
      "google-chrome"

      # Development
      "visual-studio-code"
      "intellij-idea-ce"
      "docker"
      "iterm2"

      # Communication
      "slack"
      "discord"

      # Utilities
      "rectangle"  # Window management
      "alfred"     # Spotlight replacement
      "1password" # Password manager

      # Fonts
      "font-inconsolata-nerd-font"
      "font-fira-code"
      "font-source-code-pro"
    ];
  };

  # Enable fonts
  fonts = {
    fontDir.enable = true;
    fonts = with pkgs; [
      fira-code
      fira-code-symbols
      (nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" ]; })
    ];
  };

  # Add system packages
  environment.systemPackages = with pkgs; [
    # CLI tools
    coreutils
    curl
    wget
    git
    vim
  ];

  # This value determines the nix-darwin release
  system.stateVersion = 4;
}