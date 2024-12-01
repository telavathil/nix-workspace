# nix-workspace

A reproducible macOS development environment configuration using nix-darwin and Home Manager. This repository contains everything needed to set up a consistent development environment across different macOS machines.

## Features

- macOS system configuration via nix-darwin
- Home Manager for user environment management
- Homebrew integration for macOS-specific packages
- Development tools pre-configured:
  - Git with useful aliases and settings
  - Zsh with popular plugins
  - Modern CLI tools (eza, bat, fzf, etc.)
  - Starship prompt
  - Docker support
  - Development environments (asdf, direnv)
  - Customized key bindings and aliases

## System Architecture

The configuration is built on four main components that interact with each other:

1. **flake.nix** (The Orchestrator)
   - Entry point for the configuration
   - Manages external dependencies (nixpkgs, home-manager, nix-darwin)
   - Defines system architecture (aarch64-darwin for Apple Silicon)
   - Connects system and user configurations

2. **configuration.nix** (System Settings)
   - Configures macOS system defaults
   - Manages Homebrew integration
   - Sets up system-wide packages
   - Controls macOS preferences (dock, finder, etc.)

3. **base.nix** (Core System)
   - Configures Nix daemon settings
   - Sets up garbage collection
   - Defines core system shells
   - Manages system-wide environment variables

4. **home.nix** (User Environment)
   - Manages user-specific packages
   - Configures development tools
   - Sets up shell environments
   - Imports modular configurations (git, zsh, etc.)

## Directory Structure

```
nix-workspace/
├── README.md
├── flake.nix                  # Main Nix flake file
├── flake.lock                 # Lock file for dependencies
├── hosts/                     # Host-specific configurations
│   └── laptop/               # Laptop-specific settings
│       └── configuration.nix  # Main system configuration
├── modules/                   # Reusable Nix modules
│   ├── system/               # System-level configurations
│   │   └── base.nix         # Base system settings
│   └── home/                # Home Manager modules
│       ├── git.nix          # Git configuration
│       ├── zsh.nix          # Zsh configuration
│       └── starship.nix     # Starship prompt configuration
└── home.nix                  # Main Home Manager configuration
```

## Prerequisites

1. Install Xcode Command Line Tools:
   ```bash
   xcode-select --install
   ```

2. Install Nix:
   ```bash
   sh <(curl -L https://nixos.org/nix/install)
   ```

3. Enable flakes:
   ```bash
   mkdir -p ~/.config/nix
   echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
   ```

## Quick Start

1. Install nix-darwin:
   ```bash
   nix-build https://github.com/LnL7/nix-darwin/archive/master.tar.gz -A installer
   ./result/bin/darwin-installer
   ```

2. Clone this repository:
   ```bash
   git clone https://github.com/telavathil/nix-workspace.git ~/.nix-workspace
   cd ~/.nix-workspace
   ```

3. Build and switch to the configuration:
   ```bash
   nix build .#darwinConfigurations.laptop.system
   ./result/sw/bin/darwin-rebuild switch --flake .#laptop
   ```

## Configuration Details

### System Configuration Flow

When you run `darwin-rebuild switch --flake .#laptop`:
1. **flake.nix** orchestrates the build:
   - Loads required dependencies
   - Sets up system architecture
   - Initializes nix-darwin and home-manager

2. **configuration.nix** configures the system:
   - Imports base.nix for core settings
   - Sets up macOS preferences
   - Configures system-wide packages
   - Manages Homebrew integration

3. **base.nix** establishes core functionality:
   - Configures Nix features
   - Sets up system environment
   - Manages core services
   - Handles garbage collection

4. **home.nix** sets up user environment:
   - Installs user packages
   - Configures development tools
   - Sets up shell environment
   - Manages dotfiles

### Daily Usage

#### Updating the System

```bash
# Update and switch to new configuration
cd ~/.nix-workspace
darwin-rebuild switch --flake .#laptop

# Update user configuration only
home-manager switch
```

#### Adding New Software

1. System-wide packages:
   Edit `hosts/laptop/configuration.nix`:
   ```nix
   environment.systemPackages = with pkgs; [
     your-package
   ];
   ```

2. User packages:
   Edit `home.nix`:
   ```nix
   home.packages = with pkgs; [
     your-package
   ];
   ```

3. Homebrew packages:
   Edit `configuration.nix`:
   ```nix
   homebrew = {
     enable = true;
     casks = [ "your-cask" ];
     brews = [ "your-brew" ];
   };
   ```

### Customization

#### System Configuration
- Edit `hosts/laptop/configuration.nix` for machine-specific settings and macOS defaults
- Add new modules in `modules/system/` for reusable system configurations

#### User Configuration
- Edit `home.nix` for user-specific settings
- Add new modules in `modules/home/` for reusable user configurations

## Troubleshooting

### Common Issues

1. If flake commands fail:
   ```bash
   # Check if flakes are enabled
   cat ~/.config/nix/nix.conf
   # Should contain: experimental-features = nix-command flakes
   ```

2. If Homebrew packages fail to install:
   ```bash
   # Ensure Homebrew is installed
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   ```

3. If system settings don't apply:
   ```bash
   # Rebuild and restart
   darwin-rebuild switch --flake .#laptop
   sudo reboot
   ```

4. If Home Manager fails:
   ```bash
   # Remove the generation and try again
   rm ~/.local/state/home-manager/gcroots/current-home
   home-manager switch
   ```

## Security Notes

- Sensitive files are automatically ignored via Git configuration
- API keys and credentials should be managed separately
- Binary cache is configured for faster builds
- Nix store is automatically optimized

## License

MIT