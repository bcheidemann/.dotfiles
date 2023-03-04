#!/usr/bin/env zsh

# Check we are using zsh
echo "Checking we are using ZSH..."
if [[ -v ZSH_NAME ]]; then
  echo ""
else
  echo "Error: Not using ZSH."
  echo ""
  echo "Please use ZSH to run this script."
  exit 1
fi

# Check we have cargo installed
echo "Checking we have cargo installed..."
if ! command -v cargo &> /dev/null
then
    echo "Error: cargo could not be found"
    echo ""
    echo "Please install cargo to run this script."
    exit 1
fi

# Install deno
if ! command -v deno &> /dev/null
then
    echo "Installing deno..."
    cargo install deno
    echo ""
fi

# Install with-env
if ! command -v with-env &> /dev/null
then
    echo "Installing with-env..."
    deno install --allow-read --allow-run https://deno.land/x/with_env/with-env.ts
    echo ""
fi

if ! command -v run &> /dev/null
then
    echo "Installing runrc..."
    deno install --allow-all -n run https://raw.githubusercontent.com/bcheidemann/runrc/main/src/main.ts
    echo ""
fi

# The .dotfiles repo directory
BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# git
echo "Configuring git..."
git config --global user.email "ben@heidemann.co.uk"
git config --global user.name "Ben Heidemann"
git config --global init.defaultBranch main
echo ""

# Global .gitignore
if ! git config --global core.excludesfile | grep -q "$HOME/.gitignore"; then
    echo "Linking $BASEDIR/.gitignore to $HOME/.gitignore..."
    ln -s $BASEDIR/.gitignore $HOME/.gitignore

    echo "Configuring git core.excludesfile..."
    git config --global core.excludesfile $HOME/.gitignore
    echo ""
fi

# Create .config directory
if [ ! -d "$HOME/.config" ]; then
    echo "Creating $HOME/.config directory..."
    mkdir -p $HOME/.config
    echo ""
fi

# Install nvim config
if [ ! -d "$HOME/.config/nvim" ]; then
    echo "Installing NeoVim config..."
    ln -s $BASEDIR/.config/nvim $HOME/.config/nvim
    echo ""
fi

# Global .aliases
echo "Please add the following line to your .zshrc file:"
echo " export DOTFILES_PATH=$BASEDIR"
echo " source \$DOTFILES_PATH/.aliases"
echo " export PATH=\"$DOTFILES_PATH/bin:$PATH\""
echo " export PATH=\"$HOME/.deno/bin:$PATH\""
echo ""

# Recommended bindkey commands
echo "You may also want to add the following lines to your .zshrc file:"
echo " bindkey \"^[[3~\" delete-char"
echo " bindkey \"^[[1;5C\" emacs-forward-word"
echo " bindkey \"^[[1;5D\" emacs-backward-word"
echo ""

echo "Done."
