#!/usr/bin/env bash

# Ensure sudo access
echo "This script requires sudo access. Please authenticate."
sudo echo "Successfully authenticated."

# Install build-essential
./scripts/installers/build-essential.sh

# Install xclip
./scripts/installers/xclip.sh

# Install tmux
./scripts/installers/tmux.sh

# Install cmake
./scripts/installers/cmake.sh

# Install NVM
./scripts/installers/nvm.sh

# Install NVM Bash Integration
./scripts/installers/nvm-bash-integration.sh

# Install Rust
./scripts/installers/rust.sh
source "$HOME/.cargo/env"

# Install Deno
./scripts/installers/deno.sh

# Install Zellij
./scripts/installers/zellij.sh

# Install runrc
./scripts/installers/runrc.sh

# Install global .gitignore
./scripts/installers/global-gitignore.sh

# Install Git config
./scripts/installers/git-config.sh

# Install Homebrew
./scripts/installers/homebrew.sh
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# Install GCC
./scripts/installers/gcc.sh

# Install lazygit
./scripts/installers/lazygit.sh

# Install lazydocker
./scripts/installers/lazydocker.sh

# Install GitHub CLI
./scripts/installers/gh.sh

# Install Pulumi CLI
./scripts/installers/pulumi.sh

# Patch .bashrc
./scripts/installers/bashrc.sh

### MUST RUN LAST ###

# Install SDK Man!
./scripts/installers/sdkman.sh

echo "Done."
