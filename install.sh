#!/usr/bin/env bash

# Install build-essential
./scripts/installers/build-essential.sh

# Install cmake
./scripts/installers/cmake.sh

# Install NVM
./scripts/installers/nvm.sh

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

# Patch .bashrc
./scripts/installers/bashrc.sh

echo "Done."
