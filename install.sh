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

# Install NVM
if ! command -v nvm &> /dev/null
then
    echo "Installing NVM..."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash
    echo ""
    echo "# NVM" >> $HOME/.zshrc
    echo "export NVM_DIR=\"$HOME/.nvm"\" >> $HOME/.zshrc
    echo "[ -s \"\$NVM_DIR/nvm.sh\" ] && \. \"\$NVM_DIR/nvm.sh\"  # This loads nvm" >> $HOME/.zshrc
    echo "[ -s \"\$NVM_DIR/bash_completion\" ] && \. \"\$NVM_DIR/bash_completion\"  # This loads nvm bash_completion" >> $HOME/.zshrc
    echo ""
fi

# Check we have cargo installed
if ! command -v cargo &> /dev/null
then
    echo "Installing the rust toolchain..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
    source "$HOME/.cargo/env"
    echo ""
fi

# Install deno
if ! command -v deno &> /dev/null
then
    echo "Installing deno..."
    cargo install deno
    echo ""
fi

# Install zellij
if ! command -v zellij &> /dev/null
then
    echo "Installing Zellij..."
    cargo install --locked zellij
    mkdir -p ~/.config/zellij
    zellij setup --dump-config > ~/.config/zellij/config.kdl
    echo ""
fi

# Install with-env
if ! command -v with-env &> /dev/null
then
    echo "Installing with-env..."
    deno install --allow-read --allow-run https://deno.land/x/with_env/with-env.ts
    echo ""
fi

# Install runrc
if ! command -v run &> /dev/null
then
    echo "Installing runrc..."
    deno install --allow-all -n run https://raw.githubusercontent.com/bcheidemann/runrc/main/src/main.ts
    echo ""
fi

# The .dotfiles repo directory
BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# git
# Check if git config is set
if ! git config --global user.email | grep -q "ben@heidemann.co.uk";
then
    echo "Configuring git..."
    git config --global user.email "ben@heidemann.co.uk"
    git config --global user.name "Ben Heidemann"
    git config --global init.defaultBranch main
    echo ""
fi

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

# Install wasmtime
if ! command -v wasmtime &> /dev/null
then
    echo "Installing wasmtime..."
    curl https://wasmtime.dev/install.sh -sSf | bash
    echo ""
fi

# Install tfsec
if ! command -v tfsec &> /dev/null
then
    echo "Installing tfsec..."
    # Check if Linux
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        curl -s https://raw.githubusercontent.com/aquasecurity/tfsec/master/scripts/install_linux.sh | bash
    else
        echo "WARNING: tfsec was not installed because the OS is not Linux. Please install it manually."
    fi
    echo ""
fi

# Separator
echo ""
echo "----------------------------------------"
echo ""

# Global .aliases
echo "Please add the following line to your .zshrc file:"
echo " export DOTFILES_PATH=$BASEDIR"
echo " source \$DOTFILES_PATH/.aliases"
echo " export PATH=\"$DOTFILES_PATH/bin:\$PATH\""
echo " export PATH=\"$HOME/.deno/bin:\$PATH\""
echo ""

# Recommended bindkey commands
echo "You may also want to add the following lines to your .zshrc file:"
echo " bindkey \"^[[3~\" delete-char"
echo " bindkey \"^[[1;5C\" emacs-forward-word"
echo " bindkey \"^[[1;5D\" emacs-backward-word"
echo ""

# Zellij config
echo "You may have to do some OS dependent configuration of Zellij to support copying from the terminal. See:"
echo " https://zellij.dev/documentation/faq.html#copy--paste-isnt-working-how-can-i-fix-this"
echo ""

echo "Done."
