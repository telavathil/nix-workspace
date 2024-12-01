# modules/system/base.nix
# This module contains basic system configuration for macOS
{ config, lib, pkgs, ... }:

{
  # Basic system settings
  nix = {
    settings = {
      # Enable flakes and new nix command
      experimental-features = [ "nix-command" "flakes" ];
      # Auto optimize nix store
      auto-optimise-store = true;
      # Enable binary caches
      substituters = [
        "https://cache.nixos.org"
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };
    
    # Garbage collection
    gc = {
      automatic = true;
      interval = { Hour = 24; };
      options = "--delete-older-than 30d";
    };
  };

  # Configure shells
  environment = {
    shells = with pkgs; [ bash zsh ];
    loginShell = pkgs.zsh;
    
    # System-wide variables
    variables = {
      LANG = "en_US.UTF-8";
      LC_ALL = "en_US.UTF-8";
      EDITOR = "vim";
      VISUAL = "vim";
    };
  };

  # Enable nix-index for command-not-found
  programs = {
    nix-index.enable = true;
    zsh.enable = true;
  };

  # Services
  services = {
    # Nix daemon
    nix-daemon.enable = true;
    
    # Activate system when config changes
    activate-system.enable = true;
  };
}
